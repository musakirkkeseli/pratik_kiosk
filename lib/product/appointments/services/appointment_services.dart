import '../../../features/model/api_response_model.dart';
import '../model/appointments_model.dart';
import 'IAppointment_services.dart';

class AppointmentServices extends IAppointmentServices {
  AppointmentServices(super.http);

  @override
  Future<ApiResponse<List<AppointmentsModel>>> appointmentList() async {
    return http.request<List<AppointmentsModel>>(
      requestFunction: () => http.post(appointment, data: []),
      fromJson: (json) => (json as List)
          .map((item) => AppointmentsModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
