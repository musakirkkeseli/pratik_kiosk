import '../../../core/utility/http_service.dart';
import '../../../features/model/api_response_model.dart';
import '../model/book_appointment_request_model.dart';
import '../model/book_appointment_response_model.dart';
import '../model/empty_slots_request_model.dart';
import '../model/empty_slots_response_model.dart';

abstract class IMakeAppointmentService {
  final IHttpService http;

  IMakeAppointmentService(this.http);

  final String emptySlotsPath = IMakeAppointmentServicePath.emptySlots.rawValue;
  final String createAppointmentPath =
      IMakeAppointmentServicePath.createAppointment.rawValue;

  Future<ApiResponse<EmptySlotsResponseModel>> getEmptySlots(
    EmptySlotsRequestModel request,
  );
  Future<ApiResponse<BookAppointmentResponseModel>> bookAppointment(
    BookAppointmentRequestModel request,
  );
}

enum IMakeAppointmentServicePath { emptySlots, createAppointment }

extension IMakeAppointmentServicePathExtension on IMakeAppointmentServicePath {
  String get rawValue {
    switch (this) {
      case IMakeAppointmentServicePath.emptySlots:
        return '/appointments/empty-slots';
      case IMakeAppointmentServicePath.createAppointment:
        return '/appointments/make';
    }
  }
}
