part of 'patient_registration_procedures_cubit.dart';

class PatientRegistrationProceduresState {
  final EnumPatientRegistrationProcedures currentStep;
  final PatientRegistrationProceduresRequestModel model;
  final EnumGeneralStateStatus status;
  final String? message;

  const PatientRegistrationProceduresState({
    required this.model,
    required this.currentStep,
    this.status = EnumGeneralStateStatus.initial,
    this.message,
  });

  PatientRegistrationProceduresState copyWith({
    EnumPatientRegistrationProcedures? currentStep,
    PatientRegistrationProceduresRequestModel? model,
    EnumGeneralStateStatus? status,
    String? message,
  }) {
    return PatientRegistrationProceduresState(
      currentStep: currentStep ?? this.currentStep,
      model: model ?? this.model,
      status: status ?? this.status,
      message: message,
    );
  }
}
