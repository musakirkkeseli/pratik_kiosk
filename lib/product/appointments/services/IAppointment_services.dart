import 'package:kiosk/features/model/empty_response.dart';

import '../../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../../../features/model/api_response_model.dart';
import '../model/appointments_model.dart';
import '../model/cancel_appointment_request_model.dart';

abstract class IAppointmentServices {
  final IHttpService http;

  IAppointmentServices(this.http);

  final String appointmentPath = IAppointmentServicesPath.appointment.rawValue;
  final String cancelPath = IAppointmentServicesPath.cancel.rawValue;

  Future<ApiListResponse<AppointmentsModel>> appointmentList();
  Future<ApiResponse<EmptyResponse>> cancelAppointment(
    CancelAppointmentRequestModel cancelAppointmentRequestModel,
  );
}

enum IAppointmentServicesPath { appointment, cancel }

extension IAppointmentServicesExtension on IAppointmentServicesPath {
  String get rawValue {
    switch (this) {
      case IAppointmentServicesPath.appointment:
        return '/appointments/list';
      case IAppointmentServicesPath.cancel:
        return '/appointments/cancel';
    }
  }
}
