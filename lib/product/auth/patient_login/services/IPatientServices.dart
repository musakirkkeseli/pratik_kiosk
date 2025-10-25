import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/patient_login_request_model.dart';
import '../model/patient_register_request_model.dart';
import '../model/patient_response_model.dart';
import '../model/patient_send_login_otp_response_model.dart';
import '../model/patient_validate_identity_response_model.dart';

abstract class IPatientServices {
  final IHttpService http;

  IPatientServices(this.http);

  final String userLoginPath = IPatientServicesPath.userLogin.rawValue;
  final String userRegisterPath = IPatientServicesPath.userRegister.rawValue;
  final String validateIdentityPath =
      IPatientServicesPath.validateIdentity.rawValue;
  final String sendOtpLoginPath = IPatientServicesPath.sendOtpLogin.rawValue;

  Future<ApiResponse<PatientResponseModel>> postUserLogin(PatientLoginRequestModel patientLoginRequestModel);
  Future<ApiResponse<PatientResponseModel>> postUserRegister(
    PatientRegisterRequestModel patientRegisterRequestModel,
  );
  Future<ApiResponse<PatientValidateIdentityResponseModel>>
  postValidateIdentify(String tc);
  Future<ApiResponse<PatientSendLoginOtpResponseModel>> postSendLoginOtp(
    String encryptedUserData,
  );
}

enum IPatientServicesPath {
  userLogin,
  userRegister,
  validateIdentity,
  sendOtpLogin,
}

extension IHospitalAndUserLoginServicesExtension on IPatientServicesPath {
  String get rawValue {
    switch (this) {
      case IPatientServicesPath.userLogin:
        return '/user-auth/loginVTwo';
      case IPatientServicesPath.userRegister:
        return '/user-auth/register';
      case IPatientServicesPath.validateIdentity:
        return '/user-auth/validate-identity';
      case IPatientServicesPath.sendOtpLogin:
        return '/user-auth/send-login-otp';
    }
  }
}
