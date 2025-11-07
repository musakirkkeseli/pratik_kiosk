class CancelAppointmentRequestModel {
  String? appointmentID;
  String? gUID;

  CancelAppointmentRequestModel({
    this.appointmentID,
    this.gUID,
  });

  CancelAppointmentRequestModel.fromJson(Map<String, dynamic> json) {
    appointmentID = json['AppointmentID'];
    gUID = json['GUID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (appointmentID != null) data['AppointmentID'] = appointmentID;
    if (gUID != null) data['GUID'] = gUID;
    return data;
  }
}
