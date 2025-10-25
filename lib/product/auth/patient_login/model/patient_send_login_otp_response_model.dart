class PatientSendLoginOtpResponseModel {
  String? message;
  String? phoneNumber;
  SmsResponse? smsResponse;

  PatientSendLoginOtpResponseModel(
      {this.message, this.phoneNumber, this.smsResponse});

  PatientSendLoginOtpResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    phoneNumber = json['phoneNumber'];
    smsResponse = json['smsResponse'] != null
        ? SmsResponse.fromJson(json['smsResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['phoneNumber'] = phoneNumber;
    if (smsResponse != null) {
      data['smsResponse'] = smsResponse!.toJson();
    }
    return data;
  }
}

class SmsResponse {
  Null? err;
  Data? data;

  SmsResponse({this.err, this.data});

  SmsResponse.fromJson(Map<String, dynamic> json) {
    err = json['err'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['err'] = err;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? pkgID;

  Data({this.pkgID});

  Data.fromJson(Map<String, dynamic> json) {
    pkgID = json['pkgID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pkgID'] = pkgID;
    return data;
  }
}
