class ConfigResponseModel {
  AppColor? color;
  String? logo;
  String? qrCode;
  String? hospitalName;

  ConfigResponseModel({this.color, this.logo, this.qrCode, this.hospitalName});

  ConfigResponseModel.fromJson(Map<String, dynamic> json) {
    color = json['color'] != null ? AppColor.fromJson(json['color']) : null;
    logo = json['logo'];
    qrCode = json['qrCode'];
    hospitalName = json['hospitalName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (color != null) {
      data['color'] = color!.toJson();
    }
    data['logo'] = logo;
    data['qrCode'] = qrCode;
    data['hospitalName'] = hospitalName;
    return data;
  }
}

class AppColor {
  String? primaryColor;

  AppColor({this.primaryColor});

  AppColor.fromJson(Map<String, dynamic> json) {
    primaryColor = json['primaryColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primaryColor'] = primaryColor;
    return data;
  }
}
