// ignore: depend_on_referenced_packages
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';

import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/logger_service.dart';
import '../../../../core/utility/login_status_service.dart';
import '../model/hospital_login_model.dart';
import '../services/hospital_and_user_login_services.dart';

part 'hospital_login_state.dart';

class HospitalLoginCubit extends BaseCubit<HospitalLoginState> {
  final int kioskDeviceId;
  final HospitalAndUserLoginServices service;
  HospitalLoginCubit({required this.service, required this.kioskDeviceId})
    : super(const HospitalLoginState());

  final MyLog _log = MyLog('HospitalLoginCubit');

  Future<void> postHospitalLoginCubit({
    required String username,
    required String password,
  }) async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.postLogin(username, password, kioskDeviceId);

      if (resp.success && (resp.data is HospitalLoginModel)) {
        HospitalLoginModel hospitalLoginModel = resp.data!;
        Tokens tokens = hospitalLoginModel.tokens ?? Tokens();
        final access = tokens.accessToken;
        final refresh = tokens.refreshToken;
        if (access != null || refresh != null) {
          _log.d("$access");

          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              loginStatus: EnumHospitalLoginStatus.config,
              message: resp.message,
            ),
          );
          config();
                    await LoginStatusService().login(
            accessToken: access ?? "",
            refreshToken: refresh ?? "",
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

  Future<void> config() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.getConfig();

      if (resp.success) {
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

  void continueToLogin() {
    safeEmit(state.copyWith(loginStatus: EnumHospitalLoginStatus.login));
  }
}
