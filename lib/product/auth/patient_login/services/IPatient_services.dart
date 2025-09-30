import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/patient_response_model.dart';

abstract class IpatientServices {
  final IHttpService http;

  IpatientServices(this.http);

  final String userLogin = IpatientServicesPath.userLogin.rawValue;

  Future<ApiResponse<PatientResponseModel>> postUserLogin(String tc);
}

enum IpatientServicesPath { userLogin }

extension IHospitalAndUserLoginServicesExtension on IpatientServicesPath {
  String get rawValue {
    switch (this) {
      case IpatientServicesPath.userLogin:
        return '/api/user-auth/login';
    }
  }
}
