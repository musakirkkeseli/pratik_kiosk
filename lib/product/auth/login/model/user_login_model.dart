class UserLoginModel {
  String? tc;

  UserLoginModel({this.tc});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    tc = json['tc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tc'] = tc;
    return data;
  }
}