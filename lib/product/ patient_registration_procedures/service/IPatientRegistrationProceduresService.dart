import '../../../core/utility/http_service.dart';
import '../../../features/model/api_response_model.dart';
import '../model/patient_transaction_create_request_model.dart';
import '../model/patient_transaction_create_response_model.dart';

abstract class IPatientRegistrationProceduresService {
  final IHttpService http;

  IPatientRegistrationProceduresService(this.http);

  final String patientTransactionCreatePath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionCreate
          .rawValue;

  Future<ApiResponse<PatientTransactionCreateResponseModel>>
  postPatientTransactionCreate(PatientTransactionCreateRequestModel request);
}

enum IPatientRegistrationProceduresServicePath { patientTransactionCreate }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IMandatoryServicePathExtension
    on IPatientRegistrationProceduresServicePath {
  String get rawValue {
    switch (this) {
      case IPatientRegistrationProceduresServicePath.patientTransactionCreate:
        return '/patient-transaction/create';
    }
  }
}
