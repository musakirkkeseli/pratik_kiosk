part of 'price_details_cubit.dart';

class PriceDetailsState {
  final EnumGeneralStateStatus status;
  final List<PaymentContent>? paymentContentList;
  final PatientContent? patientContent;
  final String? message;

  const PriceDetailsState({
    this.status = EnumGeneralStateStatus.initial,
    this.paymentContentList,
    this.patientContent,
    this.message,
  });

  PriceDetailsState copyWith({
    EnumGeneralStateStatus? status,
    List<PaymentContent>? paymentContentList,
    PatientContent? patientContent,
    String? message,
  }) {
    return PriceDetailsState(
      status: status ?? this.status,
      paymentContentList: paymentContentList ?? this.paymentContentList,
      patientContent: patientContent ?? this.patientContent,
      message: message,
    );
  }
}
