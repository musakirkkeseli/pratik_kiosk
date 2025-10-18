part of 'mandatory_cubit.dart';

class MandatoryState {
  final EnumGeneralStateStatus status;
  final List<MandatoryResponseModel> data;
  final List<PatientMandatoryModel> patientMandatoryData;
  final String? message;

  const MandatoryState({
    this.status = EnumGeneralStateStatus.initial,
    this.data = const [],
    this.patientMandatoryData = const [],
    this.message,
  });

  MandatoryState copyWith({
    EnumGeneralStateStatus? status,
    List<MandatoryResponseModel>? data,
    List<PatientMandatoryModel>? patientMandatoryData,
    String? message,
  }) {
    return MandatoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      patientMandatoryData: patientMandatoryData ?? this.patientMandatoryData,
      message: message,
    );
  }
}
