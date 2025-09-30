class PatientLoginModel {
  String? tcNo;
  String? accessToken;


  PatientLoginModel({this.tcNo,this.accessToken});

  PatientLoginModel.fromJson(Map<String, dynamic> json) {
    tcNo = json['tcNo'];
    tcNo = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tcNo'] = tcNo;
    data['accessToken'] = accessToken;
    return data;
  }
}