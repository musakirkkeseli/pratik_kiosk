import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/association_model.dart';
import '../model/insurance_model.dart';
import '../service/IPatientTransactionService.dart';

part 'patient_transaction_state.dart';

class PatientTransactionCubit extends BaseCubit<PatientTransactionState> {
  final IPatientTransactionService service;
  PatientTransactionCubit({required this.service})
    : super(PatientTransactionState());

  final MyLog _log = MyLog('PatientTransactionCubit');
  Future<void> fetchAssociations() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.getAssociationList();
      if (res.success == true && res.data is List<AssocationModel>) {
        _log.d("patient: $res");
        await fetchInsurances();
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            data: res.data,
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

  Future<void> fetchInsurances() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.getInsuranceList();
      if (res.success == true && res.data is List<InsuranceModel>) {
        _log.d("patient: $res");
        safeEmit(state.copyWith(insuranceData: res.data));
      }
    } on NetworkException catch (e) {
      _log.e("fetchInsurances NetworkException: ${e.message}");
    } catch (e) {
      _log.e("fetchInsurances Exception: ${e.toString()}");
    }
  }
}
