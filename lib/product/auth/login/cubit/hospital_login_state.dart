part of 'hospital_login_cubit.dart';

class HospitalLoginState {
  final EnumGeneralStateStatus status;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final int? kioskDeviceId;
  final EnumGeneralStateStatus tcStatus;
  final String? tcFromApi;
  final bool? tcVerified;

  const HospitalLoginState({
    this.status = EnumGeneralStateStatus.initial,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.kioskDeviceId,
    this.tcStatus = EnumGeneralStateStatus.initial,
    this.tcFromApi,
    this.tcVerified,
  });

  HospitalLoginState copyWith({
    EnumGeneralStateStatus? status,
    String? message,
    String? accessToken,
    String? refreshToken,
    int? kioskDeviceId,
    EnumGeneralStateStatus? tcStatus,
    String? tcFromApi,
    bool? tcVerified,
  }) {
    return HospitalLoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      kioskDeviceId: kioskDeviceId ?? this.kioskDeviceId,
      tcStatus: tcStatus ?? this.tcStatus,
      tcFromApi: tcFromApi ?? this.tcFromApi,
      tcVerified: tcVerified ?? this.tcVerified,
    );
  }
}
