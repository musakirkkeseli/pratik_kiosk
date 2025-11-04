import '../../../features/model/patient_price_detail_model.dart';

class PatientRegistrationProceduresModel {
  int? doctorId;
  String? doctorName;
  int? branchId;
  int? departmentId;
  String? branchName;
  String? appointmentID;
  String? assocationId;
  String? assocationName;
  String? gssAssocationId;
  String? insuredTypeId;
  String? insuredTypeName;
  String? patientId;
  PatientPriceDetailModel? patientPriceDetailModel;
  PatientRegistrationProceduresModel({
    this.doctorId,
    this.doctorName,
    this.branchId,
    this.departmentId,
    this.branchName,
    this.appointmentID,
    this.assocationId,
    this.assocationName,
    this.gssAssocationId,
    this.insuredTypeId,
    this.insuredTypeName,
    this.patientId,
    this.patientPriceDetailModel,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['branchId'] = branchId;
    data['departmentId'] = departmentId;
    data['appointmentID'] = appointmentID;
    data['assocationId'] = assocationId;
    data['insuredTypeId'] = insuredTypeId;
    return data;
  }
}
