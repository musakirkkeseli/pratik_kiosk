import 'dart:async';

import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/logger_service.dart';
import '../../../../core/utility/user_login_status_service.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../model/patient_register_request_model.dart';
import '../model/patient_response_model.dart';
import '../services/IPatientServices.dart';

part 'patient_login_state.dart';

class PatientLoginCubit extends BaseCubit<PatientLoginState> {
  final IPatientServices service;
  PatientLoginCubit({required this.service}) : super(PatientLoginState());

  final MyLog _log = MyLog('PatientLoginCubit');
  Future<void> userLogin() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.postUserLogin(state.tcNo);

      if (resp.success && resp.data is PatientResponseModel) {
        String? accessToken = resp.data!.accessToken;
        if (accessToken is String) {
          _log.d("data doğru");
          UserLoginStatusService().login(
            accessToken: accessToken,
            cityName: "",
            name: "",
            phone: "",
            userId: 1,
          );
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: resp.message,
              phoneNumber: "5398461416",
            ),
          );
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } else {
        _log.d("data yanlış");
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: resp.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      switch (e.statusCode) {
        case 400:
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: e.message,
              authType: AuthType.register,
            ),
          );
          break;
        default:
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: e.message,
            ),
          );
      }
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: 'Beklenmeyen hata: $e',
        ),
      );
    }
  }

  Future<void> userRegister() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.postUserRegister(
        PatientRegisterRequestModel(
          tcNo: state.tcNo,
          birthDate: state.birthDate,
        ),
      );

      if (resp.success && resp.data is PatientResponseModel) {
        String? accessToken = resp.data!.accessToken;
        if (accessToken is String) {
          _log.d("data doğru");
          UserLoginStatusService().login(
            accessToken: accessToken,
            cityName: "",
            name: "",
            phone: "",
            userId: 1,
          );
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              message: resp.message,
            ),
          );
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } else {
        _log.d("data yanlış");
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: resp.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: 'Beklenmeyen hata: $e',
        ),
      );
    }
  }

  void clean() {
    emit(
      state.copyWith(
        authType: AuthType.login,
        tcNo: "",
        otpCode: "",
        birthDate: "",
      ),
    );
    stopCounter();
  }

  void setPageType(PageType type) {
    emit(state.copyWith(pageType: type));
  }

  static const int _initialSeconds = 30;
  Timer? _timer;

  void onChanged(String value) {
    if (value.isEmpty) {
      _stopTimer();
      emit(state.copyWith(counter: null));
      return;
    }
    _startOrResetTimer();
  }

  void onChangeTcNo(String value) {
    String? tcNo = state.tcNo;
    tcNo = "$tcNo$value";
    safeEmit(state.copyWith(tcNo: tcNo));
    _startOrResetTimer();
  }

  void deleteTcNo() {
    String? tcNo = state.tcNo;
    if (tcNo.isEmpty) return;
    tcNo = tcNo.substring(0, tcNo.length - 1);
    safeEmit(state.copyWith(tcNo: tcNo));
  }

  void onChangeOtpCode(String value) {
    String? otpCode = state.otpCode;
    otpCode = "$otpCode $value";
    safeEmit(state.copyWith(otpCode: otpCode));
    _startOrResetTimer();
  }

  void deleteOtpCode() {
    String? otpCode = state.otpCode;
    otpCode = otpCode.substring(0, otpCode.length - 1);
    safeEmit(state.copyWith(otpCode: otpCode));
  }

  void _startOrResetTimer() {
    _timer?.cancel();
    emit(state.copyWith(counter: _initialSeconds));
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final counter = state.counter;
      MyLog.debug("counter: $counter");
      if (counter <= 1) {
        _stopTimer();
        emit(state.copyWith(counter: 0));
        return;
      }
      emit(state.copyWith(counter: counter - 1));
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void stopCounter() {
    _stopTimer();
    emit(state.copyWith(counter: null));
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}
