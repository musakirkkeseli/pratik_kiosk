import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/appointments_model.dart';

abstract class IAppointmentServices {
  final IHttpService http;

  IAppointmentServices(this.http);

  final String appointment = IAppointmentServicesPath.appointment.rawValue;

  Future<ApiResponse<List<AppointmentsModel>>> appointmentList();
}

enum IAppointmentServicesPath { appointment }

extension IAppointmentServicesExtension on IAppointmentServicesPath {
  String get rawValue {
    switch (this) {
      case IAppointmentServicesPath.appointment:
        return '/api/appointments/list';
    }
  }
}
