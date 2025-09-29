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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TCKNo'] = this.tCKNo;
    data['PassportNo'] = this.passportNo;
    data['UPN'] = this.uPN;
    data['HospitalID'] = this.hospitalID;
    data['DepartmentID'] = this.departmentID;
    data['DepartmentName'] = this.departmentName;
    data['BranchID'] = this.branchID;
    data['BranchName'] = this.branchName;
    data['DoctorID'] = this.doctorID;
    data['DoctorName'] = this.doctorName;
    data['AppointmentID'] = this.appointmentID;
    data['AppointmentTime'] = this.appointmentTime;
    data['GUID'] = this.gUID;
    return data;
  }
}