import 'package:kiosk/features/model/empty_response.dart';

import '../../../features/model/api_list_response_model.dart';
import '../../../features/model/api_response_model.dart';
import '../model/appointments_model.dart';
import '../model/cancel_appointment_request_model.dart';
import 'IAppointment_services.dart';

class AppointmentServices extends IAppointmentServices {
  AppointmentServices(super.http);

  @override
  Future<ApiListResponse<AppointmentsModel>> appointmentList() async {
    return http.requestList<AppointmentsModel>(
      requestFunction: () => http.post(appointmentPath),
      fromJson: (json) => AppointmentsModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<EmptyResponse>> cancelAppointment(
    CancelAppointmentRequestModel cancelAppointmentRequestModel,
  ) async {
    return http.request<EmptyResponse>(
      requestFunction: () =>
          http.post(cancelPath, data: cancelAppointmentRequestModel.toJson()),
      fromJson: (json) => EmptyResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
