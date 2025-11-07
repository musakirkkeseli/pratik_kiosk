import 'package:kiosk/core/utility/logger_service.dart';

import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/appointments_model.dart';
import '../model/cancel_appointment_request_model.dart';
import '../services/IAppointment_services.dart';

part 'appointment_state.dart';

class AppointmentCubit extends BaseCubit<AppointmentState> {
  final IAppointmentServices service;

  AppointmentCubit({required this.service}) : super(const AppointmentState());
  final MyLog _log = MyLog("AppointmentCubit");

  Future<void> fetchAppointments() async {
    try {
      final res = await service.appointmentList();

      _log.d(res.data);

      if (res.data is List<AppointmentsModel>) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            data: res.data,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  Future<void> cancelAppointment(String appointmentID, String guid) async {
    List<AppointmentsModel> appointmentsModelList = state.data;
    final appoitmentIndex = appointmentsModelList.indexWhere((appointment) {
      return appointment.appointmentID == appointmentID &&
          appointment.gUID == guid;
    });
    if (appoitmentIndex >= 0) {
      appointmentsModelList.removeAt(appoitmentIndex);
      safeEmit(state.copyWith(data: appointmentsModelList));
      try {
        final request = CancelAppointmentRequestModel(
          appointmentID: appointmentID,
          gUID: guid,
        );
        final res = await service.cancelAppointment(request);

        _log.d("Cancel response: ${res.data}");
      } on NetworkException catch (e) {
      } catch (e) {}
    }
  }

  void statusInitial() {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.initial));
  }
}
