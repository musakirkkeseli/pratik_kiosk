import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/patient_register_request_model.dart';
import '../model/patient_response_model.dart';

abstract class IPatientServices {
  final IHttpService http;

  IPatientServices(this.http);

  final String userLogin = IPatientServicesPath.userLogin.rawValue;
  final String userRegister = IPatientServicesPath.userRegister.rawValue;

  Future<ApiResponse<PatientResponseModel>> postUserLogin(String tc);
  Future<ApiResponse<PatientResponseModel>> postUserRegister(
    PatientRegisterRequestModel patientRegisterRequestModel,
  );
}

enum IPatientServicesPath { userLogin, userRegister }

extension IHospitalAndUserLoginServicesExtension on IPatientServicesPath {
  String get rawValue {
    switch (this) {
      case IPatientServicesPath.userLogin:
        return '/user-auth/login';
      case IPatientServicesPath.userRegister:
        return '/user-auth/register';
    }
  }
}
