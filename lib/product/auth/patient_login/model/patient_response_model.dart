class PatientResponseModel {
  String? accessToken;
  TokenInfo? tokenInfo;
  RequestInfo? requestInfo;

  PatientResponseModel({this.accessToken, this.tokenInfo, this.requestInfo});

  PatientResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    tokenInfo = json['tokenInfo'] != null
        ? TokenInfo.fromJson(json['tokenInfo'])
        : null;
    requestInfo = json['requestInfo'] != null
        ? RequestInfo.fromJson(json['requestInfo'])
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

  RequestInfo(
      {this.tcNo, this.hospitalId, this.hospitalName, this.requestTime});

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
