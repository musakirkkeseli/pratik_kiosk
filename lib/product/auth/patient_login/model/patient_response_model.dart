class PatientResponseModel {
  String? accessToken;
  TokenInfo? tokenInfo;
  RequestInfo? requestInfo;
  PatientData? patientData;

  PatientResponseModel({
    this.accessToken,
    this.tokenInfo,
    this.requestInfo,
    this.patientData,
  });

  PatientResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    tokenInfo = json['tokenInfo'] != null
        ? TokenInfo.fromJson(json['tokenInfo'])
        : null;
    requestInfo = json['requestInfo'] != null
        ? RequestInfo.fromJson(json['requestInfo'])
        : null;
    patientData = json['patientData'] != null
        ? PatientData.fromJson(json['patientData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    if (tokenInfo != null) {
      data['tokenInfo'] = tokenInfo!.toJson();
    }
    if (requestInfo != null) {
      data['requestInfo'] = requestInfo!.toJson();
    }
    if (patientData != null) {
      data['patientData'] = patientData!.toJson();
    }
    return data;
  }
}

class TokenInfo {
  String? expiresIn;
  String? expiresAt;
  String? tokenType;

  TokenInfo({this.expiresIn, this.expiresAt, this.tokenType});

  TokenInfo.fromJson(Map<String, dynamic> json) {
    expiresIn = json['expiresIn'];
    expiresAt = json['expiresAt'];
    tokenType = json['tokenType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expiresIn'] = expiresIn;
    data['expiresAt'] = expiresAt;
    data['tokenType'] = tokenType;
    return data;
  }
}

class RequestInfo {
  String? tcNo;
  int? hospitalId;
  String? hospitalName;
  String? requestTime;

  RequestInfo({
    this.tcNo,
    this.hospitalId,
    this.hospitalName,
    this.requestTime,
  });

  RequestInfo.fromJson(Map<String, dynamic> json) {
    tcNo = json['tcNo'];
    hospitalId = json['hospitalId'];
    hospitalName = json['hospitalName'];
    requestTime = json['requestTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tcNo'] = tcNo;
    data['hospitalId'] = hospitalId;
    data['hospitalName'] = hospitalName;
    data['requestTime'] = requestTime;
    return data;
  }
}

class PatientData {
  String? name;
  String? surname;
  String? birthDate;
  String? identityNo;

  PatientData({this.name, this.surname, this.birthDate, this.identityNo});

  PatientData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    surname = json['Surname'];
    birthDate = json['BirthDate'];
    identityNo = json['IdentityNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Surname'] = surname;
    data['BirthDate'] = birthDate;
    data['IdentityNo'] = identityNo;
    return data;
  }
}
