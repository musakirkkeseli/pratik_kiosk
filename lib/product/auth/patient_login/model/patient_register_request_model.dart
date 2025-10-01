class PatientRegisterRequestModel {
  String? tcNo;
  String? birthDate;

  PatientRegisterRequestModel({this.tcNo, this.birthDate});

  PatientRegisterRequestModel.fromJson(Map<String, dynamic> json) {
    tcNo = json['tcNo'];
    birthDate = json['birthDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tcNo'] = tcNo;
    data['birthDate'] = birthDate;
    return data;
  }
}
