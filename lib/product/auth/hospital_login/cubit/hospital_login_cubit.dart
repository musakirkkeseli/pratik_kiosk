import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';

import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/dynamic_theme_provider.dart';
import '../../../../core/utility/logger_service.dart';
import '../../../../core/utility/login_status_service.dart';
import '../model/config_response_model.dart';
import '../model/hospital_login_request_model.dart';
import '../model/hospital_login_response_model.dart';
import '../services/IHospital_and_user_login_services.dart';

part 'hospital_login_state.dart';

class HospitalLoginCubit extends BaseCubit<HospitalLoginState> {
  final String kioskDeviceId;
  final IHospitalAndUserLoginServices service;
  HospitalLoginCubit({required this.service, required this.kioskDeviceId})
    : super(HospitalLoginState());

  final MyLog _log = MyLog('HospitalLoginCubit');

  Future<void> postHospitalLoginCubit({
    required String username,
    required String password,
  }) async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    HospitalLoginRequestModel requestModel = HospitalLoginRequestModel(
      username: username,
      password: password,
      kioskDeviceId: kioskDeviceId,
    );
    try {
      final resp = await service.postLogin(requestModel);

      if (resp.success && (resp.data is HospitalLoginResponseModel)) {
        HospitalLoginResponseModel hospitalLoginModel = resp.data!;
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
          await LoginStatusService().saveToken(
            accessToken: access ?? "",
            refreshToken: refresh ?? "",
          );
          config();
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

      if (resp.success && resp.data is ConfigResponseModel) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            message: resp.message,
            primaryColor: resp.data!.color!.primaryColor ?? "",
          ),
        );
        DynamicThemeProvider().updateTheme(resp.data ?? ConfigResponseModel());
        await Future.delayed(const Duration(milliseconds: 5000));
        await LoginStatusService().login();
      } else {
        LoginStatusService().logout();
      }
    } on NetworkException {
      LoginStatusService().logout();
    } catch (e) {
      LoginStatusService().logout();
    }
  }
}
