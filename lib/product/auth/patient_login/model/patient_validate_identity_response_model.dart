class PatientValidateIdentityResponseModel {
  String? encryptedUserData;
  String? phoneNumber;

  PatientValidateIdentityResponseModel({
    this.encryptedUserData,
    this.phoneNumber,
  });

  PatientValidateIdentityResponseModel.fromJson(Map<String, dynamic> json) {
    encryptedUserData = json['encryptedUserData'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encryptedUserData'] = encryptedUserData;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
