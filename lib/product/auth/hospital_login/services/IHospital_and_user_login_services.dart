import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/config_response_model.dart';
import '../model/hospital_login_request_model.dart';
import '../model/hospital_login_response_model.dart';
import '../model/refresh_token_mode.dart';

abstract class IHospitalAndUserLoginServices {
  final IHttpService http;

  IHospitalAndUserLoginServices(this.http);

  final String hospitalConfigPath =
      IHospitalAndUserLoginServicesPath.hospitalConfig.rawValue;
  final String hospitalLoginPath =
      IHospitalAndUserLoginServicesPath.hospitalLogin.rawValue;

  final String refreshTokenPath =
      IHospitalAndUserLoginServicesPath.refreshToken.rawValue;

  Future<ApiResponse<ConfigResponseModel>> getConfig();

  Future<ApiResponse<HospitalLoginResponseModel>> postLogin(
    HospitalLoginRequestModel requestModel,
  );

  Future<ApiResponse<RefreshTokenResponseModel>> postRefreshToken(
    String refreshToken,
  );
}

enum IHospitalAndUserLoginServicesPath {
  hospitalLogin,
  refreshToken,
  hospitalConfig,
}

extension IHospitalAndUserLoginServicesExtension
    on IHospitalAndUserLoginServicesPath {
  String get rawValue {
    switch (this) {
      case IHospitalAndUserLoginServicesPath.hospitalLogin:
        return '/auth/login';

      case IHospitalAndUserLoginServicesPath.refreshToken:
        return '/auth/refresh-token';

      case IHospitalAndUserLoginServicesPath.hospitalConfig:
        return '/hospital/config';
    }
  }
}
