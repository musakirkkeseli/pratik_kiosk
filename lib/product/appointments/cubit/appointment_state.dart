part of 'appointment_cubit.dart';

class AppointmentState {
  final EnumGeneralStateStatus status;
  final List<AppointmentsModel> data;
  final String? message;

  const AppointmentState({
    this.status = EnumGeneralStateStatus.loading,
    this.data = const [],
    this.message,
  });

  AppointmentState copyWith({
    EnumGeneralStateStatus? status,
    List<AppointmentsModel>? data,
    String? message,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message,
    );
  }
}
