class MandatoryRequestModel {
  String? assocationId;
  String? insuranceTypeId;

  MandatoryRequestModel({this.assocationId, this.insuranceTypeId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AssocationId'] = assocationId;
    data['InsuranceTypeId'] = insuranceTypeId;
    return data;
  }
}
