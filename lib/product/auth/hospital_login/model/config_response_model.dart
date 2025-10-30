class ConfigResponseModel {
  AppColor? color;
  String? logo;
  String? qrCode;

  ConfigResponseModel({this.color, this.logo, this.qrCode});

  ConfigResponseModel.fromJson(Map<String, dynamic> json) {
    color = json['color'] != null ? AppColor.fromJson(json['color']) : null;
    logo = json['logo'];
    qrCode = json['qrCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (color != null) {
      data['color'] = color!.toJson();
    }
    data['logo'] = logo;
    data['qrCode'] = qrCode;
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
