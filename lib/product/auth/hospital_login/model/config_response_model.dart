class ConfigResponseModel {
  String? primaryColor;

  ConfigResponseModel({this.primaryColor});

  ConfigResponseModel.fromJson(Map<String, dynamic> json) {
    primaryColor = json['primaryColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primaryColor'] = primaryColor;
    return data;
  }
}