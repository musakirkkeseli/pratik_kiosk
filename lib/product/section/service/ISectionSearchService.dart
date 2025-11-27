import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../model/section_model.dart';

abstract class ISectionSearchService {
  final IHttpService http;

  ISectionSearchService(this.http);

  final String patientTransactionBranchPath =
      ISectionSearchServicePath.patientTransactionBranch.rawValue;
  final String appointmentBranchPath =
      ISectionSearchServicePath.appointmentBranch.rawValue;

  Future<ApiListResponse<SectionItems>> getPatientTransactionBranch();
  Future<ApiListResponse<SectionItems>> getAppointmentBranch();
}

enum ISectionSearchServicePath { patientTransactionBranch, appointmentBranch }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension ISearchServicePathExtension on ISectionSearchServicePath {
  String get rawValue {
    switch (this) {
      case ISectionSearchServicePath.patientTransactionBranch:
        return '/clinical-resources/branches/patient-transaction';
      case ISectionSearchServicePath.appointmentBranch:
        return "/clinical-resources/branches/appointment";
    }
  }
}
