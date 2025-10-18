class InsuranceModel {
  String? insuredTypeId;
  String? insuredTypeName;
  String? insuredTypeCode;

  InsuranceModel({
    this.insuredTypeId,
    this.insuredTypeName,
    this.insuredTypeCode,
  });

  InsuranceModel.fromJson(Map<String, dynamic> json) {
    insuredTypeId = json['InsuredTypeId'];
    insuredTypeName = json['InsuredTypeName'];
    insuredTypeCode = json['InsuredTypeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InsuredTypeId'] = insuredTypeId;
    data['InsuredTypeName'] = insuredTypeName;
    data['InsuredTypeCode'] = insuredTypeCode;
    return data;
  }
}
