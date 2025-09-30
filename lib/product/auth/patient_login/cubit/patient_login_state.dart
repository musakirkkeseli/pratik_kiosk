part of 'patient_login_cubit.dart';

enum AuthType { register, login }

class PatientLoginState {
  final String? message;
  final AuthType authType;
  final EnumGeneralStateStatus tcStatus;

  const PatientLoginState({
    this.message,
    this.authType = AuthType.login,
    this.tcStatus = EnumGeneralStateStatus.initial,
  });

  PatientLoginState copyWith({
    String? message,
    AuthType? authType,
    EnumGeneralStateStatus? tcStatus,
  }) {
    return PatientLoginState(
      message: message ?? this.message,
      authType: authType ?? this.authType,
      tcStatus: tcStatus ?? this.tcStatus,
    );
  }
}
