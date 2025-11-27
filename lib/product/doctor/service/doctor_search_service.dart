import '../../../features/model/api_list_response_model.dart';
import '../model/doctor_model.dart';
import 'IDoctorSearchService.dart';

class DoctorSearchService extends IDoctorSearchService {
  DoctorSearchService(super.http);

  @override
  Future<ApiListResponse<DoctorItems>> getPatientTransactionDoctor(
    String branchId,
  ) async {
    return http.requestList<DoctorItems>(
      requestFunction: () =>
          http.get("$patientTransactionDoctorPath/$branchId"),
      fromJson: (json) => DoctorItems.fromJson(json),
    );
  }

  @override
  Future<ApiListResponse<DoctorItems>> getAppointmentDoctor(
    String branchId,
  ) async {
    return http.requestList<DoctorItems>(
      requestFunction: () => http.get("$appointmentDoctorPath/$branchId"),
      fromJson: (json) => DoctorItems.fromJson(json),
    );
  }
}
