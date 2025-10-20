import '../../../features/model/patient_mandatory_model.dart';

class PatientTransactionCreateRequestModel {
  int? doctorId;
  int? departmentId;
  int? associationId;
  List<PatientMandatoryModel>? mandatoryFields;

  PatientTransactionCreateRequestModel({
    this.doctorId,
    this.departmentId,
    this.associationId,
    this.mandatoryFields,
  });

  PatientTransactionCreateRequestModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    departmentId = json['departmentId'];
    associationId = json['associationId'];
    if (json['mandatoryFields'] != null) {
      mandatoryFields = <PatientMandatoryModel>[];
      json['mandatoryFields'].forEach((v) {
        mandatoryFields!.add(PatientMandatoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['departmentId'] = departmentId;
    data['associationId'] = associationId;
    if (mandatoryFields != null) {
      data['mandatoryFields'] = mandatoryFields!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}
