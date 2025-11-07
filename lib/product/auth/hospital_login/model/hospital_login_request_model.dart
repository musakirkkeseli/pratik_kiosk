class HospitalLoginRequestModel {
  String? username;
  String? password;
  String? kioskDeviceId;

  HospitalLoginRequestModel({this.username, this.password, this.kioskDeviceId});

  HospitalLoginRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    kioskDeviceId = json['kiosk_device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['kiosk_id'] = kioskDeviceId;
    return data;
  }
}
