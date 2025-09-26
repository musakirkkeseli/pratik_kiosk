part of 'hospital_login_cubit.dart';

class HospitalLoginState {
  final EnumGeneralStateStatus status;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final EnumGeneralStateStatus tcStatus;

  const HospitalLoginState({
    this.status = EnumGeneralStateStatus.initial,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.tcStatus = EnumGeneralStateStatus.initial,
  });

  HospitalLoginState copyWith({
    EnumGeneralStateStatus? status,
    String? message,
    String? accessToken,
    String? refreshToken,
    EnumGeneralStateStatus? tcStatus,
  }) {
    return HospitalLoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tcStatus: tcStatus ?? this.tcStatus,
    );
  }
}
