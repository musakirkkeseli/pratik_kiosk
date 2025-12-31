// part of 'patient_transaction_cubit.dart';

// class PatientTransactionState {
//   final EnumGeneralStateStatus status;
//   final List<AssocationModel> data;
//   final List<InsuranceModel> insuranceData;
//   final String? message;

//   const PatientTransactionState({
//     this.status = EnumGeneralStateStatus.initial,
//     this.data = const [],
//     this.insuranceData = const [],
//     this.message,
//   });

//   PatientTransactionState copyWith({
//     EnumGeneralStateStatus? status,
//     List<AssocationModel>? data,
//     List<InsuranceModel>? insuranceData,
//     String? message,
//   }) {
//     return PatientTransactionState(
//       status: status ?? this.status,
//       data: data ?? this.data,
//       insuranceData: insuranceData ?? this.insuranceData,
//       message: message,
//     );
//   }
// }