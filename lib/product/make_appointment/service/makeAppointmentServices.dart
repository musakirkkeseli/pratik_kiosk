import '../../../features/model/api_response_model.dart';
import '../model/book_appointment_request_model.dart';
import '../model/book_appointment_response_model.dart';
import '../model/empty_slots_request_model.dart';
import '../model/empty_slots_response_model.dart';
import 'IMakeAppointment_service.dart';

class MakeAppointmentService extends IMakeAppointmentService {
  MakeAppointmentService(super.http);

  @override
  Future<ApiResponse<EmptySlotsResponseModel>> getEmptySlots(
    EmptySlotsRequestModel request,
  ) async {
    final response = await http.requestList<SlotItem>(
      requestFunction: () => http.post(emptySlotsPath, data: request.toJson()),
      fromJson: (json) => SlotItem.fromJson(json),
    );

    final model = EmptySlotsResponseModel(slots: response.data);
    return ApiResponse(
      success: response.success ?? false,
      data: model,
      message: response.message ?? '',
    );
  }

  @override
  Future<ApiResponse<BookAppointmentResponseModel>> bookAppointment(
    BookAppointmentRequestModel request,
  ) async {
    return http.request<BookAppointmentResponseModel>(
      requestFunction: () =>
          http.post(createAppointmentPath, data: request.toJson()),
      fromJson: (json) =>
          BookAppointmentResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
