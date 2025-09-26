import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../../patient_login/model/patient_login_model.dart';
import '../model/hospital_login_model.dart';
import '../model/refresh_token_mode.dart';

abstract class IHospitalAndUserLoginServices {
  final IHttpService http;

  IHospitalAndUserLoginServices(this.http);

  final String hospitalLogin =
      IHospitalAndUserLoginServicesPath.hospitalLogin.rawValue;
  final String userLogin = IHospitalAndUserLoginServicesPath.userLogin.rawValue;
  final String refreshTokenPath =
      IHospitalAndUserLoginServicesPath.refreshToken.rawValue;

  Future<ApiResponse<HospitalLoginModel>> postLogin(
    String userName,
    String password,
    int kioskDeviceId,
  );
  Future<ApiResponse<PatientLoginModel>> postLoginByTc(String tc);
  Future<ApiResponse<RefreshTokenResponseModel>> postRefreshToken(
    String refreshToken,
  );
}

enum IHospitalAndUserLoginServicesPath {
  hospitalLogin,
  userLogin,
  refreshToken,
}

extension IHospitalAndUserLoginServicesExtension
    on IHospitalAndUserLoginServicesPath {
  String get rawValue {
    switch (this) {
      case IHospitalAndUserLoginServicesPath.hospitalLogin:
        return '/api/auth/login';
      case IHospitalAndUserLoginServicesPath.userLogin:
        return '/api/user-auth/login';
      case IHospitalAndUserLoginServicesPath.refreshToken:
        return '/api/auth/refresh-token';
    }
  }
}
