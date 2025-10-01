import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../model/doctor_model.dart';

abstract class IDoctorSearchService {
  final IHttpService http;

  IDoctorSearchService(this.http);

  final String listDoctorPath = IDoctorSearchServicePath.listDoctor.rawValue;

  Future<ApiListResponse<DoctorItems>> getListDoctor(int branchId);
}

enum IDoctorSearchServicePath { listDoctor }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IDoctorSearchServicePathExtension on IDoctorSearchServicePath {
  String get rawValue {
    switch (this) {
      case IDoctorSearchServicePath.listDoctor:
        return '/clinical-resources/doctors';
    }
  }
}
