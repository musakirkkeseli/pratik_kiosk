// part of 'patient_transaction_cubit.dart';

import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/Patient_transaction_request_model.dart';

class PatientTransactionState {
  final EnumGeneralStateStatus status;
  final List<AssociationsModel> data;
  final String? message;

  const PatientTransactionState({
    this.status = EnumGeneralStateStatus.initial,
    this.data = const [],
    this.message,
  });

  PatientTransactionState copyWith({
    EnumGeneralStateStatus? status,
    List<AssociationsModel>? data,
    String? message,
  }) {
    return PatientTransactionState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message,
    );
  }
}