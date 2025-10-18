part of 'price_details_cubit.dart';

class PriceDetailsState {
  final EnumGeneralStateStatus status;
  final List<GetPatientTranscationDet>? patientTranscationDet;
  final GetPatientTranscationProcessList? patientTranscationProcessList;
  final String? message;

  const PriceDetailsState({
    this.status = EnumGeneralStateStatus.initial,
    this.patientTranscationDet,
    this.patientTranscationProcessList,
    this.message,
  });

  PriceDetailsState copyWith({
    EnumGeneralStateStatus? status,
    List<GetPatientTranscationDet>? patientTranscationDet,
    GetPatientTranscationProcessList? patientTranscationProcessList,
    String? message,
  }) {
    return PriceDetailsState(
      status: status ?? this.status,
      patientTranscationDet:
          patientTranscationDet ?? this.patientTranscationDet,
      patientTranscationProcessList:
          patientTranscationProcessList ?? this.patientTranscationProcessList,
      message: message,
    );
  }
}
