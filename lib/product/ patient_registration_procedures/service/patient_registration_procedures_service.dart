import '../../../features/model/api_response_model.dart';
import '../../../features/model/patient_price_detail_model.dart';
import '../model/patient_transaction_create_request_model.dart';
import '../model/patient_transaction_create_response_model.dart';
import '../model/patient_transaction_revenue_response_model.dart';
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

  @override
  Future<ApiResponse<PatientTransactionRevenueResponseModel>>
  postPatientTransactionRevenue(PatientPriceDetailModel request) async {
    return http.request<PatientTransactionRevenueResponseModel>(
      requestFunction: () =>
          http.post(patientTransactionRevenuePath, data: request.toJson()),
      fromJson: (json) => PatientTransactionRevenueResponseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<ApiResponse<PatientTransactionRevenueResponseModel>>
  postPatientTransactionCancel(String patientId) async {
    return http.request<PatientTransactionRevenueResponseModel>(
      requestFunction: () =>
          http.post(patientTransactionCancelPath, data: patientId),
      fromJson: (json) => PatientTransactionRevenueResponseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }
}
