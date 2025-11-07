import '../../../../features/model/api_response_model.dart';
import '../model/config_response_model.dart';
import '../model/hospital_login_request_model.dart';
import '../model/hospital_login_response_model.dart';
import '../model/refresh_token_mode.dart';
import 'IHospital_and_user_login_services.dart';

class HospitalAndUserLoginServices extends IHospitalAndUserLoginServices {
  HospitalAndUserLoginServices(super.http);

  @override
  Future<ApiResponse<HospitalLoginResponseModel>> postLogin(
    HospitalLoginRequestModel requestModel,
  ) async {
    return http.request<HospitalLoginResponseModel>(
      requestFunction: () =>
          http.post(hospitalLoginPath, data: requestModel.toJson()),
      fromJson: (json) =>
          HospitalLoginResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<ConfigResponseModel>> getConfig() async {
    return http.request<ConfigResponseModel>(
      requestFunction: () => http.get(hospitalConfigPath),
      fromJson: (json) =>
          ConfigResponseModel.fromJson(json as Map<String, dynamic>),
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
