class PatientLoginModel {
  String? tcNo;

  PatientLoginModel({this.tcNo});

  PatientLoginModel.fromJson(Map<String, dynamic> json) {
    tcNo = json['tcNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tcNo'] = tcNo;
    return data;
  }
}