class EmptySlotsResponseModel {
  List<SlotItem>? slots;

  EmptySlotsResponseModel({this.slots});

  EmptySlotsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      slots = <SlotItem>[];
      json['data'].forEach((v) {
        slots!.add(SlotItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (slots != null) {
      data['data'] = slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SlotItem {
  String? hospitalID;
  String? departmentID;
  String? doctorID;
  String? slotID;
  String? startTime;
  String? finishTime;
  String? appType;
  String? isReserved;

  SlotItem({
    this.hospitalID,
    this.departmentID,
    this.doctorID,
    this.slotID,
    this.startTime,
    this.finishTime,
    this.appType,
    this.isReserved,
  });

  SlotItem.fromJson(Map<String, dynamic> json) {
    hospitalID = json['HospitalID'];
    departmentID = json['DepartmentID'];
    doctorID = json['DoctorID'];
    slotID = json['SlotID'];
    startTime = json['StartTime'];
    finishTime = json['FinishTime'];
    appType = json['AppType'];
    isReserved = json['IsReserved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['HospitalID'] = hospitalID;
    data['DepartmentID'] = departmentID;
    data['DoctorID'] = doctorID;
    data['SlotID'] = slotID;
    data['StartTime'] = startTime;
    data['FinishTime'] = finishTime;
    data['AppType'] = appType;
    data['IsReserved'] = isReserved;
    return data;
  }

  // Helper method to get formatted time
  String getFormattedTime() {
    if (startTime == null) return '';
    try {
      // Parse: "25.11.2025T09:10:00"
      final parts = startTime!.split('T');
      if (parts.length == 2) {
        final timePart = parts[1].substring(0, 5); // Get "09:10"
        return timePart;
      }
    } catch (e) {
      // ignore
    }
    return startTime ?? '';
  }

  String getFormattedDate() {
    if (startTime == null) return '';
    try {
      final parts = startTime!.split('T');
      if (parts.isNotEmpty) {
        return parts[0]; // Get "25.11.2025"
      }
    } catch (e) {
      // ignore
    }
    return startTime ?? '';
  }

  // Check if slot is available based on IsReserved field
  bool get isAvailable => isReserved == '0';
}
