part of 'mandatory_cubit.dart';

class MandatoryState {
  final EnumGeneralStateStatus status;
  final List<MandatoryResponseModel> data;
  final List<PatientMandatoryModel> patientMandatoryData;
  final String? message;
  final List<String> requiredWarning;

  const MandatoryState({
    this.status = EnumGeneralStateStatus.initial,
    this.data = const [],
    this.patientMandatoryData = const [],
    this.message,
    this.requiredWarning = const [],
  });

  MandatoryState copyWith({
    EnumGeneralStateStatus? status,
    List<MandatoryResponseModel>? data,
    List<PatientMandatoryModel>? patientMandatoryData,
    String? message,
    List<String>? requiredWarning,
  }) {
    return MandatoryState(
      status: status ?? this.status,
      data: data ?? this.data,
      patientMandatoryData: patientMandatoryData ?? this.patientMandatoryData,
      message: message,
      requiredWarning: requiredWarning ?? this.requiredWarning,
    );
  }
}
