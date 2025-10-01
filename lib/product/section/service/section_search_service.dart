import '../../../features/model/api_list_response_model.dart';
import '../model/section_model.dart';
import 'ISectionSearchService.dart';

class SectionSearchService extends ISectionSearchService {
  SectionSearchService(super.http);

  @override
  Future<ApiListResponse<SectionItems>> getBranchAndDeptListRequest() async {
    return http.requestList<SectionItems>(
      requestFunction: () => http.get(branchAndDepPath),
      fromJson: (json) => SectionItems.fromJson(json),
    );
  }
}
