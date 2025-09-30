part of 'appointment_cubit.dart';

@immutable
class AppointmentSummary {
  final EnumGeneralStateStatus status;
  final String? branchName;
  final String? doctorName;
  const AppointmentSummary({
    this.branchName,
    this.doctorName,
    this.status = EnumGeneralStateStatus.initial,
  });
}

@immutable
class AppointmentState {
  final EnumGeneralStateStatus status;
  final List<AppointmentSummary>
  data; // success'ta branchName + doctorName listesi
  final String? message; // failure için hata mesajı (opsiyonel)

  const AppointmentState({
    this.status = EnumGeneralStateStatus.initial,
    this.data = const [],
    this.message,
  });

  AppointmentState copyWith({
    EnumGeneralStateStatus? status,
    List<AppointmentSummary>? data,
    String? message,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message,
    );
  }
}
