part of 'patient_login_cubit.dart';

enum AuthType { register, login }

class PatientLoginState {
  final String? message;
  final AuthType authType;
  final EnumGeneralStateStatus status;

  const PatientLoginState({
    this.message,
    this.authType = AuthType.login,
    this.status = EnumGeneralStateStatus.initial,
  });

  PatientLoginState copyWith({
    String? message,
    AuthType? authType,
    EnumGeneralStateStatus? status,
  }) {
    return PatientLoginState(
      message: message ?? this.message,
      authType: authType ?? this.authType,
      status: status ?? this.status,
    );
  }
}
