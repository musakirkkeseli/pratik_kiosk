part of 'hospital_login_cubit.dart';

enum EnumHospitalLoginStatus { login, config }

class HospitalLoginState {
  final EnumGeneralStateStatus status;
  final EnumHospitalLoginStatus loginStatus;
  final String? message;
  final String? primaryColor;

  const HospitalLoginState({
    this.status = EnumGeneralStateStatus.initial,
    this.loginStatus = EnumHospitalLoginStatus.login,
    this.message,
    this.primaryColor,
  });

  HospitalLoginState copyWith({
    EnumGeneralStateStatus? status,
    EnumHospitalLoginStatus? loginStatus,
    String? message,
    String? primaryColor,
  }) {
    return HospitalLoginState(
      status: status ?? this.status,
      loginStatus: loginStatus ?? this.loginStatus,
      message: message ?? this.message,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}
