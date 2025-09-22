// ignore: depend_on_referenced_packages
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';

import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/cache_manager.dart';
import '../../../../core/utility/logger_service.dart';
import '../services/hospital_and_user_login_services.dart';

part 'hospital_login_state.dart';

class HospitalLoginCubit extends BaseCubit<HospitalLoginState> {
  final HospitalAndUserLoginServices service;
  HospitalLoginCubit({required this.service})
    : super(const HospitalLoginState());

  final MyLog _log = MyLog('HospitalLoginCubit');

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
      final resp = await service.postLogin(u, p);

      if (resp.success && (resp.data?.accessToken != null)) {
        final access = resp.data!.accessToken!;
        final refresh = resp.data?.refreshToken;

        await CacheManager().writeString('token', access);
        if (refresh != null) {
          await CacheManager().writeString('refreshToken', refresh);
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
      // ---- HER KOD İÇİN AYRI EMIT + EARLY RETURN
      if (e.statusCode == 404) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: '404 bulunamadı',
          ),
        );
        return;
      }
      if (e.statusCode == 401) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: '401 yetkisiz işlem',
          ),
        );
        return;
      }
      if (e.statusCode == 400) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: '400 bad request',
          ),
        );
        return;
      }
      if (e.statusCode == 405) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: '405 geçersiz metod',
          ),
        );
        return;
      }
      // default
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

  Future<void> verifyPatientTcCubit({required String userEnteredTc}) async {
    final tc = userEnteredTc.trim();

    if (tc.isEmpty) {
      safeEmit(
        state.copyWith(
          tcStatus: EnumGeneralStateStatus.failure,
          message: 'TC alanı boş olamaz.',
        ),
      );
      return;
    }
    if (!RegExp(r'^\d{11}$').hasMatch(tc)) {
      safeEmit(
        state.copyWith(
          tcStatus: EnumGeneralStateStatus.failure,
          message: 'Lütfen 11 haneli geçerli bir TC girin.',
        ),
      );
      return;
    }

    safeEmit(
      state.copyWith(tcStatus: EnumGeneralStateStatus.loading, message: null),
    );

    try {
      final resp = await service.postLoginByTc(tc);
      final apiTc = resp.data?.tc;
      final matches = (apiTc != null && apiTc == tc);

      if (resp.success && matches) {
        safeEmit(
          state.copyWith(
            tcStatus: EnumGeneralStateStatus.success,
            tcFromApi: apiTc,
            tcVerified: true,
            message: resp.message,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            tcStatus: EnumGeneralStateStatus.failure,
            tcFromApi: apiTc,
            tcVerified: false,
            message: resp.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      // ---- HER KOD İÇİN AYRI EMIT + EARLY RETURN
      if (e.statusCode == 404) {
        safeEmit(
          state.copyWith(
            tcStatus: EnumGeneralStateStatus.failure,
            message: '404 bulunamadı',
          ),
        );
        return;
      }
      if (e.statusCode == 401) {
        safeEmit(
          state.copyWith(
            tcStatus: EnumGeneralStateStatus.failure,
            message: '401 yetkisiz işlem',
          ),
        );
        return;
      }
      if (e.statusCode == 400) {
        safeEmit(
          state.copyWith(
            tcStatus: EnumGeneralStateStatus.failure,
            message: '400 bad request',
          ),
        );
        return;
      }
      if (e.statusCode == 405) {
        safeEmit(
          state.copyWith(
            tcStatus: EnumGeneralStateStatus.failure,
            message: '405 geçersiz metod',
          ),
        );
        return;
      }
      // default
      safeEmit(
        state.copyWith(
          tcStatus: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
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
