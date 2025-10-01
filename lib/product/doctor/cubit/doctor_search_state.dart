part of 'doctor_search_cubit.dart';

class DoctorSearchState {
  final EnumGeneralStateStatus status;
  final List<DoctorItems> data;
  final String? message;

  const DoctorSearchState({
    this.status = EnumGeneralStateStatus.initial,
    this.data = const [],
    this.message,
  });

  DoctorSearchState copyWith({
    EnumGeneralStateStatus? status,
    List<DoctorItems>? data,
    String? message,
  }) {
    return DoctorSearchState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message,
    );
  }
}
