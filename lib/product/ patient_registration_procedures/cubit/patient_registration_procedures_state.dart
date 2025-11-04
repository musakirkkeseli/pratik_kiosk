part of 'patient_registration_procedures_cubit.dart';

class PatientRegistrationProceduresState {
  final EnumPatientRegistrationProcedures currentStep;
  final PatientRegistrationProceduresModel model;
  final EnumGeneralStateStatus status;
  final String? message;
  final EnumPaymentResultType? paymentResultType;
  final String? totalAmount;

  const PatientRegistrationProceduresState({
    required this.model,
    required this.currentStep,
    this.status = EnumGeneralStateStatus.initial,
    this.message,
    this.paymentResultType,
    this.totalAmount,
  });

  PatientRegistrationProceduresState copyWith({
    EnumPatientRegistrationProcedures? currentStep,
    PatientRegistrationProceduresModel? model,
    EnumGeneralStateStatus? status,
    String? message,
    EnumPaymentResultType? paymentResultType,
    String? totalAmount,
  }) {
    return PatientRegistrationProceduresState(
      currentStep: currentStep ?? this.currentStep,
      model: model ?? this.model,
      status: status ?? this.status,
      message: message,
      paymentResultType: paymentResultType ?? this.paymentResultType,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
