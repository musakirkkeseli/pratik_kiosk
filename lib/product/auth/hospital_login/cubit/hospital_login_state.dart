part of 'hospital_login_cubit.dart';

class HospitalLoginState {
  final EnumGeneralStateStatus status;
  final String? accessToken;
  final String? refreshToken;
  final String? message;

  const HospitalLoginState({
    this.status = EnumGeneralStateStatus.initial,
    this.accessToken,
    this.refreshToken,
    this.message,
  });

  HospitalLoginState copyWith({
    EnumGeneralStateStatus? status,
    String? accessToken,
    String? refreshToken,
    String? message,
  }) {
    return HospitalLoginState(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      message: message ?? this.message,
    );
  }
}
