import '../../../features/model/api_list_response_model.dart';
import '../model/section_model.dart';
import 'ISectionSearchService.dart';

class SectionSearchService extends ISectionSearchService {
  SectionSearchService(super.http);

  @override
  Future<ApiListResponse<SectionItems>> getPatientTransactionBranch() async {
    return http.requestList<SectionItems>(
      requestFunction: () => http.get(patientTransactionBranchPath),
      fromJson: (json) => SectionItems.fromJson(json),
    );
  }

  @override
  Future<ApiListResponse<SectionItems>> getAppointmentBranch() async {
    return http.requestList<SectionItems>(
      requestFunction: () => http.get(appointmentBranchPath),
      fromJson: (json) => SectionItems.fromJson(json),
    );
  }
}
