class DoctorItems {
  int? doctorId;
  String? doctorTitle;
  String? doctorName;
  String? doctorImage;
  int? branchId;
  String? branchName;
  int? departmentId;
  String? departmentName;

  DoctorItems({
    this.doctorId,
    this.doctorTitle,
    this.doctorName,
    this.doctorImage,
    this.branchId,
    this.branchName,
    this.departmentId,
    this.departmentName,
  });

  DoctorItems.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    doctorTitle = json['doctorTitle'];
    doctorName = json['doctorName'];
    doctorImage = json['doctorImage'];
    branchId = json['branchId'];
    branchName = json['branchName'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['doctorTitle'] = doctorTitle;
    data['doctorName'] = doctorName;
    data['doctorImage'] = doctorImage;
    data['branchId'] = branchId;
    data['branchName'] = branchName;
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    return data;
  }
}
