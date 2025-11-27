class DoctorItems {
  String? doctorId;
  String? doctorTitle;
  String? doctorName;
  String? doctorImage;
  String? branchId;
  String? branchName;
  String? departmentId;
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
    doctorId = json['ID'];
    doctorTitle = json['Title'];
    doctorName = json['Name'];
    doctorImage = json['DoctorImage'];
    branchId = json['BranchID'];
    branchName = json['BranchName'];
    departmentId = json['DeptID'];
    departmentName = json['DeptName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = doctorId;
    data['Title'] = doctorTitle;
    data['Name'] = doctorName;
    data['DoctorImage'] = doctorImage;
    data['BranchID'] = branchId;
    data['BranchName'] = branchName;
    data['DeptID'] = departmentId;
    data['DeptName'] = departmentName;
    return data;
  }
}
