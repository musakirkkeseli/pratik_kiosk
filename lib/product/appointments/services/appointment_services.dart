import '../../../features/model/api_list_response_model.dart';
import '../model/appointments_model.dart';
import 'IAppointment_services.dart';

class AppointmentServices extends IAppointmentServices {
  AppointmentServices(super.http);

  @override
  Future<ApiListResponse<AppointmentsModel>> appointmentList() async {
    return http.requestList<AppointmentsModel>(
      requestFunction: () => http.post(appointment),
      fromJson: (json) => AppointmentsModel.fromJson(json),
    );
  }
}
