// ignore: depend_on_referenced_packages
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';

import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/cache_manager.dart'; // CacheManager için
import '../../../../core/utility/logger_service.dart';
import '../services/hospital_login_services.dart';

part 'hospital_login_state.dart';

class HospitalLoginCubit extends BaseCubit<HospitalLoginState> {
  final HospitalLoginServices service;
  HospitalLoginCubit({required this.service})
    : super(const HospitalLoginState());

  MyLog _log = MyLog('HospitalLoginCubit');

  Future<void> postUserLoginCubit({
    required String username,
    required String password,
  }) async {
    final u = username.trim();
    final p = password;

    if (u.isEmpty || p.isEmpty) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: 'Kullanıcı adı ve şifre zorunludur.',
        ),
      );
      return;
    }

    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.postLogin(username, password);
      _log.d(resp.data!.toJson());

      if (resp.success) {
        if (resp.data?.accessToken != null) {
          await CacheManager().writeString(
            'token',
            resp.data?.accessToken ?? '',
          );
          if (resp.data?.refreshToken != null) {
            await CacheManager().writeString(
              'refreshToken',
              resp.data?.refreshToken ?? '',
            );
          }

          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              accessToken: resp.data?.accessToken,
              refreshToken: resp.data?.refreshToken,
            ),
          );
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: 'Geçersiz yanıt: accessToken boş.',
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
}
