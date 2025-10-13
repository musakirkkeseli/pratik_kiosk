import '../../../../features/model/api_response_model.dart';
import '../model/hospital_login_model.dart';
import '../model/refresh_token_mode.dart';
import 'IHospital_and_user_login_services.dart';

class HospitalAndUserLoginServices extends IHospitalAndUserLoginServices {
  HospitalAndUserLoginServices(super.http);

  @override
  Future<ApiResponse<HospitalLoginModel>> postLogin(
    String userName,
    String password,
    int kioskDeviceId,
  ) async {
    return http.request<HospitalLoginModel>(
      requestFunction: () => http.post(
          hospitalLoginPath,
        data: {
          'username': userName,
          'password': password,
          'kiosk_device_id': kioskDeviceId,
        },
      ),
      fromJson: (json) =>
          HospitalLoginModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<HospitalLoginModel>> getConfig() async {
    return http.request<HospitalLoginModel>(
      requestFunction: () => http.get(
        hospitalConfigPath,

      ),
      fromJson: (json) =>
          HospitalLoginModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<RefreshTokenResponseModel>> postRefreshToken(
    String refreshToken,
  ) {
    return http.request<RefreshTokenResponseModel>(
      requestFunction: () => http.post(refreshTokenPath),
      fromJson: (json) =>
          RefreshTokenResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
