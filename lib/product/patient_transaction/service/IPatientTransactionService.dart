import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../model/Patient_transaction_request_model.dart';

abstract class IPatientTransactionService {
  final IHttpService http;

  IPatientTransactionService(this.http);

  final String associationList =
      IPatientTransactionServicePath.associationList.rawValue;

  Future<ApiListResponse<AssociationsModel>> getAssociationList();
}

enum IPatientTransactionServicePath { associationList }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension ISearchServicePathExtension on IPatientTransactionServicePath {
  String get rawValue {
    switch (this) {
      case IPatientTransactionServicePath.associationList:
        return '/patient-transaction/associations';
    }
  }
}
