import 'package:kiosk/product/patient_transaction/cubit/patient_transaction_state.dart';
import 'package:kiosk/product/patient_transaction/model/Patient_transaction_request_model.dart';
import 'package:kiosk/product/patient_transaction/service/patient_transaction_service.dart';

import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';

class PatientTransactionCubit extends BaseCubit<PatientTransactionState> {
  final PatientTransactionService service;
  PatientTransactionCubit({required this.service})
    : super(PatientTransactionState());

  final MyLog _log = MyLog('PatientTransactionCubit');
  Future<void> fetchAssociations() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.getAssociationList();
      if (res.success == true && res.data is List<AssociationsModel>) {
        _log.d("patient: $res");
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
}
