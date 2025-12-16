class BookAppointmentRequestModel {
  String? slotId;

  BookAppointmentRequestModel({this.slotId});

  BookAppointmentRequestModel.fromJson(Map<String, dynamic> json) {
    slotId = json['slotId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slotId'] = slotId;
    return data;
  }
}
