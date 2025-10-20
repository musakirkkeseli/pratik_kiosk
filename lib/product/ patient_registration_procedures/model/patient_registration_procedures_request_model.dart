class PatientRegistrationProceduresModel {
  int? doctorId;
  String? doctorName;
  int? branchId;
  int? departmentId;
  String? branchName;
  String? assocationId;
  String? assocationName;
  String? gssAssocationId;
  String? insuredTypeId;
  String? insuredTypeName;
  String? patientId;
  PatientRegistrationProceduresModel({
    this.doctorId,
    this.doctorName,
    this.branchId,
    this.departmentId,
    this.branchName,
    this.assocationId,
    this.assocationName,
    this.gssAssocationId,
    this.insuredTypeId,
    this.insuredTypeName,
    this.patientId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['branchId'] = branchId;
    data['departmentId'] = departmentId;
    data['assocationId'] = assocationId;
    data['insuredTypeId'] = insuredTypeId;
    return data;
  }
}
