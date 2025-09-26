class RefreshTokenResponseModel {
  String? accessToken;
  String? refreshToken;
  String? expiresIn;

  RefreshTokenResponseModel(
      {this.accessToken, this.refreshToken, this.expiresIn});

  RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['expiresIn'] = expiresIn;
    return data;
  }
}