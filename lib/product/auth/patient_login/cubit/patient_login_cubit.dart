import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/logger_service.dart';
import '../../../../core/utility/user_login_status_service.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../model/patient_response_model.dart';
import '../services/patient_services.dart';

part 'patient_login_state.dart';

class PatientLoginCubit extends BaseCubit<PatientLoginState> {
  final PatientServices service;
  PatientLoginCubit({required this.service}) : super(PatientLoginState());

  final MyLog _log = MyLog('PatientLoginCubit');
  Future<void> userLogin({required String tcNo}) async {
    _log.d("tcNo $tcNo");
    safeEmit(state.copyWith(tcStatus: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.postUserLogin(tcNo);

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
              tcStatus: EnumGeneralStateStatus.success,
              message: resp.message,
            ),
          );
        } else {
          safeEmit(
            state.copyWith(
              tcStatus: EnumGeneralStateStatus.failure,
              message: resp.message,
            ),
          );
        }
      } else {
        _log.d("data yanlış");
        safeEmit(
          state.copyWith(
            tcStatus: EnumGeneralStateStatus.failure,
            message: resp.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      switch (e.statusCode) {
        case 400:
          safeEmit(
            state.copyWith(
              tcStatus: EnumGeneralStateStatus.success,
              message: e.message,
              authType: AuthType.register,
            ),
          );
          break;
        default:
          safeEmit(
            state.copyWith(
              tcStatus: EnumGeneralStateStatus.failure,
              message: e.message,
            ),
          );
      }
    } catch (e) {
      safeEmit(
        state.copyWith(
          tcStatus: EnumGeneralStateStatus.failure,
          message: 'Beklenmeyen hata: $e',
        ),
      );
    }
  }
}
