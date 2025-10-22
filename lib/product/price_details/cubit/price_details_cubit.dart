import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/model/patient_price_detail_model.dart';
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
      if (res.success && res.data is PatientPriceDetailModel) {
        _log.d(res);
        List<PaymentContent>? paymentContentList = res.data!.paymentContent;
        PatientContent? patientContent = res.data!.patientContent;
        if (paymentContentList is List<PaymentContent> &&
            patientContent is PatientContent) {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              paymentContentList: paymentContentList,
              patientContent: patientContent,
            ),
          );
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
