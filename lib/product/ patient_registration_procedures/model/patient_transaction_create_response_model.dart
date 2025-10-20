class PatientTransactionCreateResponseModel {
  String? patientId;
  String? patientProcessId;
  String? serviceId;
  String? errorId;
  String? errorMessage;

  PatientTransactionCreateResponseModel({
    this.patientId,
    this.patientProcessId,
    this.serviceId,
    this.errorId,
    this.errorMessage,
  });

  PatientTransactionCreateResponseModel.fromJson(Map<String, dynamic> json) {
    patientId = json['PatientID'];
    patientProcessId = json['PatientProcessId'];
    serviceId = json['ServiceId'];
    errorId = json['ErrorId'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientID'] = patientId;
    data['PatientProcessId'] = patientProcessId;
    data['ServiceId'] = serviceId;
    data['ErrorId'] = errorId;
    data['ErrorMessage'] = errorMessage;
    return data;
  }
}
