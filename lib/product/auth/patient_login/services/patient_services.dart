import '../../../../features/model/api_response_model.dart';

import '../model/patient_register_request_model.dart';
import '../model/patient_response_model.dart';
import 'IPatient_services.dart';

class PatientServices extends IpatientServices {
  PatientServices(super.http);

  @override
  Future<ApiResponse<PatientResponseModel>> postUserLogin(String tcNo) {
    return http.request<PatientResponseModel>(
      requestFunction: () => http.post(userLogin, data: {'tcNo': tcNo}),
      fromJson: (json) =>
          PatientResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<PatientResponseModel>> postUserRegister(
    PatientRegisterRequestModel patientRegisterRequestModel,
  ) {
    return http.request<PatientResponseModel>(
      requestFunction: () =>
          http.post(userLogin, data: patientRegisterRequestModel.toJson()),
      fromJson: (json) =>
          PatientResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
