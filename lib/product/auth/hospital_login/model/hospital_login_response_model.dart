class HospitalLoginResponseModel {
  int? kioskDeviceId;
  Tokens? tokens;

  HospitalLoginResponseModel({this.kioskDeviceId, this.tokens});

  HospitalLoginResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? tokensMap;
    if (json['tokens'] is Map<String, dynamic>) {
      tokensMap = json['tokens'] as Map<String, dynamic>;
    } else if (json['data'] is Map<String, dynamic> &&
        (json['data']['tokens'] is Map<String, dynamic>)) {
      tokensMap =
          (json['data'] as Map<String, dynamic>)['tokens']
              as Map<String, dynamic>;
    }
    if (tokensMap != null) {
      tokens = Tokens.fromJson(tokensMap);
    }

    final kid = json['kioskDeviceId'];
    if (kid is int) {
      kioskDeviceId = kid;
    } else if (kid != null) {
      kioskDeviceId = int.tryParse(kid.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['kioskDeviceId'] = kioskDeviceId;
    if (tokens != null) data['tokens'] = tokens!.toJson();
    return data;
  }
}

class Tokens {
  String? accessToken;
  String? refreshToken;
  String? expiresIn;

  Tokens({this.accessToken, this.refreshToken, this.expiresIn});

  Tokens.fromJson(Map<String, dynamic> json) {
    accessToken =
        (json['accessToken'] ??
                json['access_token'] ??
                json['token'] ??
                json['jwt'])
            ?.toString();
    refreshToken = (json['refreshToken'] ?? json['refresh_token'])?.toString();
    expiresIn = json['expiresIn']?.toString();
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresIn': expiresIn,
  };
}
