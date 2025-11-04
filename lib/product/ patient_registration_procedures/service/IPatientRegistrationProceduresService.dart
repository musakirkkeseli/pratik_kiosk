import '../../../core/utility/http_service.dart';
import '../../../features/model/api_response_model.dart';
import '../../../features/model/empty_response.dart';
import '../../../features/model/patient_price_detail_model.dart';
import '../model/patient_transaction_create_request_model.dart';
import '../model/patient_transaction_create_response_model.dart';
import '../model/patient_transaction_revenue_response_model.dart';

abstract class IPatientRegistrationProceduresService {
  final IHttpService http;

  IPatientRegistrationProceduresService(this.http);

  final String patientTransactionCreatePath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionCreate
          .rawValue;
  final String patientTransactionRevenuePath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionRevenue
          .rawValue;
  final String patientTransactionCancelPath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionCancel
          .rawValue;
  final String patientTransactionDetailsPath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionDetails
          .rawValue;

  Future<ApiResponse<PatientTransactionCreateResponseModel>>
  postPatientTransactionCreate(PatientTransactionCreateRequestModel request);
  Future<ApiResponse<PatientTransactionRevenueResponseModel>>
  postPatientTransactionRevenue(PatientTransactionDetailsResponseModel request);
  Future<ApiResponse<EmptyResponse>> postPatientTransactionCancel(
    String patientId,
  );
  Future<ApiResponse<PatientTransactionDetailsResponseModel>>
  postPatientTransactionDetails(String patientId);
}

enum IPatientRegistrationProceduresServicePath {
  patientTransactionCreate,
  patientTransactionRevenue,
  patientTransactionCancel,
  patientTransactionDetails,
}

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IMandatoryServicePathExtension
    on IPatientRegistrationProceduresServicePath {
  String get rawValue {
    switch (this) {
      case IPatientRegistrationProceduresServicePath.patientTransactionCreate:
        return '/patient-transaction/create';
      case IPatientRegistrationProceduresServicePath.patientTransactionRevenue:
        return '/patient-transaction/revenue';
      case IPatientRegistrationProceduresServicePath.patientTransactionCancel:
        return '/patient-transaction/cancel';
      case IPatientRegistrationProceduresServicePath.patientTransactionDetails:
        return '/patient-transaction/transaction-details';
    }
  }
}
