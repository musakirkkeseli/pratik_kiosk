import '../../../features/model/api_list_response_model.dart';
import '../model/doctor_model.dart';
import 'IDoctorSearchService.dart';

class DoctorSearchService extends IDoctorSearchService {
  DoctorSearchService(super.http);

  @override
  Future<ApiListResponse<DoctorItems>> getListDoctor(int branchId) async {
    return http.requestList<DoctorItems>(
      requestFunction: () => http.get("$listDoctorPath/$branchId"),
      fromJson: (json) => DoctorItems.fromJson(json),
    );
  }
}
