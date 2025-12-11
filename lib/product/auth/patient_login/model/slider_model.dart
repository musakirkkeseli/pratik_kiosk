class SliderModel {
  int? id;
  int? kioskDeviceId;
  int? orderNo;
  String? name;
  String? path;

  SliderModel(
      {this.id, this.kioskDeviceId, this.orderNo, this.name, this.path});

  SliderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kioskDeviceId = json['kiosk_device_id'];
    orderNo = json['order_no'];
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['kiosk_device_id'] = kioskDeviceId;
    data['order_no'] = orderNo;
    data['name'] = name;
    data['path'] = path;
    return data;
  }
}
