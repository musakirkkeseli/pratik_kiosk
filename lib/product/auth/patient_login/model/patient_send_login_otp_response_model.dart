class PatientSendLoginOtpResponseModel {
  String? message;
  String? phoneNumber;

  PatientSendLoginOtpResponseModel(
      {this.message, this.phoneNumber});

  PatientSendLoginOtpResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
