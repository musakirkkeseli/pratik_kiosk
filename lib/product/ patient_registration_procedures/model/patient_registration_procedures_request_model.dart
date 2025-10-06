class PatientRegistrationProceduresRequestModel {
  int? doctorId;
  String? doctorName;
  int? departmentId;
  String? departmentName;
  int? associationId;
  String? associationName;

  PatientRegistrationProceduresRequestModel({
    this.doctorId,
    this.doctorName,
    this.departmentId,
    this.departmentName,
    this.associationId,
    this.associationName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['departmentId'] = departmentId;
    data['associationId'] = associationId;
    return data;
  }
}
