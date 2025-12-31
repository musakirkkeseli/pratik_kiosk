class MandatoryRequestModel {
  String? assocationId;

  MandatoryRequestModel({this.assocationId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AssocationId'] = assocationId;
    return data;
  }
}
