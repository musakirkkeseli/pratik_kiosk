part of 'hospital_login_cubit.dart';

class HospitalLoginState {
  final EnumGeneralStateStatus status;
  final String? message;
  final EnumGeneralStateStatus tcStatus;

  const HospitalLoginState({
    this.status = EnumGeneralStateStatus.initial,
    this.message,
    this.tcStatus = EnumGeneralStateStatus.initial,
  });

  HospitalLoginState copyWith({
    EnumGeneralStateStatus? status,
    String? message,
    EnumGeneralStateStatus? tcStatus,
  }) {
    return HospitalLoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      tcStatus: tcStatus ?? this.tcStatus,
    );
  }
}
