import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/price_model.dart';
import '../service/IPriceDetailsService.dart';

part 'price_details_state.dart';

class PriceDetailsCubit extends BaseCubit<PriceDetailsState> {
  final IPriceDetailsService service;
  final String patientId;

  PriceDetailsCubit({required this.service, required this.patientId})
    : super(PriceDetailsState());

  final MyLog _log = MyLog('PriceDetailsCubit');

  Future<void> fetchPatientPrice() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.postPatientPrice(patientId);
      if (res.data is PatientPriceModel) {
        _log.d(res);
        PatientTranscationList? patientTranscationList =
            res.data!.patientTranscationList;
        PatientTranscationProcessList? patientTranscationProcessList =
            res.data!.patientTranscationProcessList;
        if (patientTranscationList is PatientTranscationList &&
            patientTranscationProcessList is PatientTranscationProcessList) {
          if (patientTranscationList.getPatientTranscationDet
                  is List<GetPatientTranscationDet> &&
              patientTranscationProcessList.getPatientTranscationProcessList
                  is GetPatientTranscationProcessList) {
            safeEmit(
              state.copyWith(
                status: EnumGeneralStateStatus.success,
                patientTranscationDet:
                    patientTranscationList.getPatientTranscationDet!,
                patientTranscationProcessList: patientTranscationProcessList
                    .getPatientTranscationProcessList,
              ),
            );
          } else {
            safeEmit(
              state.copyWith(
                status: EnumGeneralStateStatus.failure,
                message: ConstantString().errorOccurred,
              ),
            );
          }
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: res.message,
            ),
          );
        }
      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
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
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }
}
