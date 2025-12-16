class EmptySlotsRequestModel {
  int? doctorId;
  int? departmentId;

  EmptySlotsRequestModel({this.doctorId, this.departmentId});

  EmptySlotsRequestModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    departmentId = json['departmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['departmentId'] = departmentId;
    return data;
  }
}
