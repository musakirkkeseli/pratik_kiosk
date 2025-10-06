part of 'patient_login_cubit.dart';

enum AuthType { register, login }

class PatientLoginState {
  final String? message;
  final AuthType authType;
  final EnumGeneralStateStatus status;
  final int counter;

  const PatientLoginState({
    this.counter = 0,
    this.message,
    this.authType = AuthType.login,
    this.status = EnumGeneralStateStatus.initial,
  });

  PatientLoginState copyWith({
    String? message,
    AuthType? authType,
    EnumGeneralStateStatus? status,
    int? counter,
  }) {
    return PatientLoginState(
      message: message ?? this.message,
      authType: authType ?? this.authType,
      status: status ?? this.status,
      counter: counter ?? this.counter,
    );
  }
}
