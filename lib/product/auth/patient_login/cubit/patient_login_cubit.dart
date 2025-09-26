import '../../../../core/exception/network_exception.dart';
import '../../../../core/utility/base_cubit.dart';
import '../../../../core/utility/logger_service.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../hospital_login/services/hospital_and_user_login_services.dart';
import '../model/patient_login_model.dart';

part 'patient_login_state.dart';

class PatientLoginCubit extends BaseCubit<PatientLoginState> {
  final HospitalAndUserLoginServices service;
  PatientLoginCubit({required this.service}) : super(PatientLoginState());

  final MyLog _log = MyLog('PatientLoginCubit');
  Future<void> verifyPatientTcCubit({required String tcNo}) async {
    _log.d("tcNo $tcNo");
    safeEmit(state.copyWith(tcStatus: EnumGeneralStateStatus.loading));

    try {
      final resp = await service.postLoginByTc(tcNo);

      if (resp.success && resp.data is PatientLoginModel) {
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
