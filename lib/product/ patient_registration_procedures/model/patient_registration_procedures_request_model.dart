import '../../../features/model/patient_price_detail_model.dart';

class PatientRegistrationProceduresModel {
  String? doctorId;
  String? doctorName;
  String? departmentId;
  String? departmentName;
  String? branchId;
  String? branchName;
  String? appointmentId;
  String? assocationId;
  String? assocationName;
  String? gssAssocationId;
  String? insuredTypeId;
  String? insuredTypeName;
  String? patientId;
  PatientTransactionDetailsResponseModel? patientPriceDetailModel;
  List<PaymentContent>? paymentContentList;
  PatientContent? patientContent;
  PatientRegistrationProceduresModel({
    this.doctorId,
    this.doctorName,
    this.branchId,
    this.branchName,
    this.departmentId,
    this.departmentName,
    this.appointmentId,
    this.assocationId,
    this.assocationName,
    this.gssAssocationId,
    this.insuredTypeId,
    this.insuredTypeName,
    this.patientId,
    this.patientPriceDetailModel,
    this.paymentContentList,
    this.patientContent,
  });
}
