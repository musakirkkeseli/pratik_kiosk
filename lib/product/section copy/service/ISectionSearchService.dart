import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../../section/model/section_model.dart';

abstract class ISectionSearchService {
  final IHttpService http;

  ISectionSearchService(this.http);

  final String branchAndDepPath =
      ISectionSearchServicePath.branchAndDep.rawValue;

  Future<ApiListResponse<SectionItems>> getBranchAndDeptListRequest();
}

enum ISectionSearchServicePath { branchAndDep }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension ISearchServicePathExtension on ISectionSearchServicePath {
  String get rawValue {
    switch (this) {
      case ISectionSearchServicePath.branchAndDep:
        return '/branch-and-dept/list';
    }
  }
}
