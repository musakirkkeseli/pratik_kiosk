import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/patient_register_request_model.dart';
import '../model/patient_response_model.dart';

abstract class IpatientServices {
  final IHttpService http;

  IpatientServices(this.http);

  final String userLogin = IpatientServicesPath.userLogin.rawValue;
  final String userRegister = IpatientServicesPath.userRegister.rawValue;

  Future<ApiResponse<PatientResponseModel>> postUserLogin(String tc);
  Future<ApiResponse<PatientResponseModel>> postUserRegister(
    PatientRegisterRequestModel patientRegisterRequestModel,
  );
}

enum IpatientServicesPath { userLogin, userRegister }

extension IHospitalAndUserLoginServicesExtension on IpatientServicesPath {
  String get rawValue {
    switch (this) {
      case IpatientServicesPath.userLogin:
        return '/user-auth/login';
      case IpatientServicesPath.userRegister:
        return '/user-auth/register';
    }
  }
}
