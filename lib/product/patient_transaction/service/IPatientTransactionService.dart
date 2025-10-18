import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../model/association_model.dart';
import '../model/insurance_model.dart';

abstract class IPatientTransactionService {
  final IHttpService http;

  IPatientTransactionService(this.http);

  final String associationListPath =
      IPatientTransactionServicePath.associationList.rawValue;
  final String insuranceListPath =
      IPatientTransactionServicePath.insuranceList.rawValue;

  Future<ApiListResponse<AssocationModel>> getAssociationList();
  Future<ApiListResponse<InsuranceModel>> getInsuranceList();
}

enum IPatientTransactionServicePath { associationList, insuranceList }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension ISearchServicePathExtension on IPatientTransactionServicePath {
  String get rawValue {
    switch (this) {
      case IPatientTransactionServicePath.associationList:
        return '/patient-transaction/associations';
      case IPatientTransactionServicePath.insuranceList:
        return '/patient-transaction/insured-types';
    }
  }
}
