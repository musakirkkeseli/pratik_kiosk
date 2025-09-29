part of 'appointment_cubit.dart';

enum AppointmentStatus { initial, loading, success, failure }

@immutable
class AppointmentSummary {
  final String? branchName;
  final String? doctorName;
  const AppointmentSummary({this.branchName, this.doctorName});
}

@immutable
class AppointmentState {
  final AppointmentStatus status;
  final List<AppointmentSummary> data; // success'ta branchName + doctorName listesi
  final String? message;               // failure için hata mesajı (opsiyonel)

  const AppointmentState({
    this.status = AppointmentStatus.initial,
    this.data = const [],
    this.message,
  });

  AppointmentState copyWith({
    AppointmentStatus? status,
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
