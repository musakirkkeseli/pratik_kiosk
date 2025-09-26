part of 'patient_login_cubit.dart';

class PatientLoginState {
  final String? message;

  final EnumGeneralStateStatus tcStatus;

  const PatientLoginState({
    this.message,

    this.tcStatus = EnumGeneralStateStatus.initial,
  });

  PatientLoginState copyWith({
    String? message,

    EnumGeneralStateStatus? tcStatus,
  }) {
    return PatientLoginState(
      message: message ?? this.message,

      tcStatus: tcStatus ?? this.tcStatus,
    );
  }
}
