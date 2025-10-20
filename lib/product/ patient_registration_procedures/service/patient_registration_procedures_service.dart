import '../../../features/model/api_response_model.dart';
import '../model/patient_transaction_create_request_model.dart';
import '../model/patient_transaction_create_response_model.dart';
import 'IPatientRegistrationProceduresService.dart';

class PatientRegistrationProceduresService
    extends IPatientRegistrationProceduresService {
  PatientRegistrationProceduresService(super.http);

  @override
  Future<ApiResponse<PatientTransactionCreateResponseModel>>
  postPatientTransactionCreate(
    PatientTransactionCreateRequestModel request,
  ) async {
    return http.request<PatientTransactionCreateResponseModel>(
      requestFunction: () =>
          http.post(patientTransactionCreatePath, data: request.toJson()),
      fromJson: (json) => PatientTransactionCreateResponseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }
}
