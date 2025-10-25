class PatientLoginRequestModel {
  String? encryptedUserData;
  String? otpCode;

  PatientLoginRequestModel({this.encryptedUserData, this.otpCode});

  PatientLoginRequestModel.fromJson(Map<String, dynamic> json) {
    encryptedUserData = json['encryptedUserData'];
    otpCode = json['otpCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encryptedUserData'] = encryptedUserData;
    data['otpCode'] = otpCode;
    return data;
  }
}
