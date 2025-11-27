import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../model/doctor_model.dart';

abstract class IDoctorSearchService {
  final IHttpService http;

  IDoctorSearchService(this.http);

  final String patientTransactionDoctorPath =
      IDoctorSearchServicePath.patientTransactionDoctor.rawValue;
  final String appointmentDoctorPath =
      IDoctorSearchServicePath.appointmentDoctor.rawValue;

  Future<ApiListResponse<DoctorItems>> getPatientTransactionDoctor(String branchId);
  Future<ApiListResponse<DoctorItems>> getAppointmentDoctor(String branchId);
}

enum IDoctorSearchServicePath { patientTransactionDoctor, appointmentDoctor }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IDoctorSearchServicePathExtension on IDoctorSearchServicePath {
  String get rawValue {
    switch (this) {
      case IDoctorSearchServicePath.patientTransactionDoctor:
        return '/clinical-resources/doctors/patient-transaction';
      case IDoctorSearchServicePath.appointmentDoctor:
        return "/clinical-resources/doctors/appointment";
    }
  }
}
