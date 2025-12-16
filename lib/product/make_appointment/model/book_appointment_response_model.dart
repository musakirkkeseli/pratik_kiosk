class BookAppointmentResponseModel {
  String? appointmentID;
  String? guid;
  String? timestamp;

  BookAppointmentResponseModel({
    this.appointmentID,
    this.guid,
    this.timestamp,
  });

  BookAppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    appointmentID = json['AppointmentID'];
    guid = json['GUID'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AppointmentID'] = appointmentID;
    data['GUID'] = guid;
    data['timestamp'] = timestamp;
    return data;
  }
}
