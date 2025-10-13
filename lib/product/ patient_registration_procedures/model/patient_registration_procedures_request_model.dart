class PatientRegistrationProceduresRequestModel {
  int? doctorId;
  String? doctorName;
  int? branchId;
  int? departmentId;
  String? branchName;
  int? associationId;
  String? associationName;

  PatientRegistrationProceduresRequestModel({
    this.doctorId,
    this.doctorName,
    this.branchId,
    this.departmentId,
    this.branchName,
    this.associationId,
    this.associationName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['branchId'] = branchId;
    data['departmentId'] = departmentId;
    data['associationId'] = associationId;
    return data;
  }
}
