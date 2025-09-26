// ignore: depend_on_referenced_packages
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';

import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/cache_manager.dart';
import '../../../../core/utility/logger_service.dart';
import '../../patient_login/model/user_login_model.dart';
import '../services/hospital_and_user_login_services.dart';

part 'hospital_login_state.dart';

class HospitalLoginCubit extends BaseCubit<HospitalLoginState> {
  final int kioskDeviceId;
  final HospitalAndUserLoginServices service;
  HospitalLoginCubit({required this.service, required this.kioskDeviceId})
    : super(const HospitalLoginState());

  final MyLog _log = MyLog('HospitalLoginCubit');

  Future<void> postUserLoginCubit({
    required String username,
    required String password,
  }) async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.postLogin(username, password, kioskDeviceId);

      if (resp.success && (resp.data?.tokens?.accessToken != null)) {
        final access = resp.data?.tokens?.accessToken;
        final refresh = resp.data?.tokens?.refreshToken;

        if (resp.success && access != null && access.isNotEmpty) {
          await CacheManager().writeString(
            'accessToken',
            access,
          ); // interceptor onRequest için
          await CacheManager().writeString('accessTokenKey', access);
        } // retry okuması için

        if (refresh != null) {
          await CacheManager().writeString(
            'refreshToken',
            refresh,
          ); // opsiyonel
          await CacheManager().writeString(
            'refreshTokenKey',
            refresh,
          ); // retry okuması için
        }

        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            accessToken: access,
            refreshToken: refresh,
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

  Future<void> verifyPatientTcCubit({required String tcNo}) async {
    _log.d("tcNo $tcNo");
    safeEmit(state.copyWith(tcStatus: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.postLoginByTc(tcNo);

      if (resp.success && resp.data is UserLoginModel) {
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
    } on NetworkException catch (e) {
      switch (e.statusCode) {
        case 400:
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
