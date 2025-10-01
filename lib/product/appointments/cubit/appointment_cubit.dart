import 'package:kiosk/core/utility/logger_service.dart';

import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/appointments_model.dart';
import '../services/appointment_services.dart';

part 'appointment_state.dart';

class AppointmentCubit extends BaseCubit<AppointmentState> {
  final AppointmentServices service;

  AppointmentCubit({required this.service}) : super(const AppointmentState());
  Future<void> fetchAppointments() async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.appointmentList();
      final data = res.data ?? <AppointmentsModel>[];

      MyLog.debug("appointments: $data");

      safeEmit(
        state.copyWith(status: EnumGeneralStateStatus.success, data: data),
      );
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
          message: 'Beklenmeyen hata: $e',
        ),
      );
    }
  }
}
