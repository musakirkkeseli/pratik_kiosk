import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/hospital_login_model.dart';
import '../model/user_login_model.dart';

abstract class IhospitalAndUserLoginServices {
  final HttpService http;

  IhospitalAndUserLoginServices(this.http);

  final String hospitalLogin =
      IhospitalAndUserLoginServicesPath.hospitalLogin.rawValue;
    final String userLogin =
      IhospitalAndUserLoginServicesPath.userLogin.rawValue;

  Future<ApiResponse<HospitalLoginModel>> postLogin(
    String userName,
    String password,
    int kioskDeviceId,
  );
  Future<ApiResponse<UserLoginModel>> postLoginByTc(String tc);
}

enum IhospitalAndUserLoginServicesPath { hospitalLogin,userLogin }

extension IhospitalAndUserLoginServicesExtension
    on IhospitalAndUserLoginServicesPath {
  String get rawValue {
    switch (this) {
      case IhospitalAndUserLoginServicesPath.hospitalLogin:
        return '/api/auth/login';
      case IhospitalAndUserLoginServicesPath.userLogin:
        return '/kioskFakeLogin.php';
    }
    
  }
}
