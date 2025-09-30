part of 'hospital_login_cubit.dart';

class HospitalLoginState {
  final EnumGeneralStateStatus status;
  final String? message;

  const HospitalLoginState({
    this.status = EnumGeneralStateStatus.initial,
    this.message,
  });

  HospitalLoginState copyWith({
    EnumGeneralStateStatus? status,
    String? message,
  }) {
    return HospitalLoginState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
