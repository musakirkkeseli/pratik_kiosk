class AppointmentsModel {
  String? tCKNo;
  String? passportNo;
  String? uPN;
  String? hospitalID;
  String? departmentID;
  String? departmentName;
  String? branchID;
  String? branchName;
  String? doctorID;
  String? doctorName;
  String? appointmentID;
  String? appointmentTime;
  String? gUID;

  AppointmentsModel(
      {this.tCKNo,
      this.passportNo,
      this.uPN,
      this.hospitalID,
      this.departmentID,
      this.departmentName,
      this.branchID,
      this.branchName,
      this.doctorID,
      this.doctorName,
      this.appointmentID,
      this.appointmentTime,
      this.gUID});

  AppointmentsModel.fromJson(Map<String, dynamic> json) {
    tCKNo = json['TCKNo'];
    passportNo = json['PassportNo'];
    uPN = json['UPN'];
    hospitalID = json['HospitalID'];
    departmentID = json['DepartmentID'];
    departmentName = json['DepartmentName'];
    branchID = json['BranchID'];
    branchName = json['BranchName'];
    doctorID = json['DoctorID'];
    doctorName = json['DoctorName'];
    appointmentID = json['AppointmentID'];
    appointmentTime = json['AppointmentTime'];
    gUID = json['GUID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TCKNo'] = tCKNo;
    data['PassportNo'] = passportNo;
    data['UPN'] = uPN;
    data['HospitalID'] = hospitalID;
    data['DepartmentID'] = departmentID;
    data['DepartmentName'] = departmentName;
    data['BranchID'] = branchID;
    data['BranchName'] = branchName;
    data['DoctorID'] = doctorID;
    data['DoctorName'] = doctorName;
    data['AppointmentID'] = appointmentID;
    data['AppointmentTime'] = appointmentTime;
    data['GUID'] = gUID;
    return data;
  }
}