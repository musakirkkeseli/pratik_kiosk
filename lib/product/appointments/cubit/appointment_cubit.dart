import 'package:kiosk/core/utility/logger_service.dart';
import 'package:meta/meta.dart';

import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/appointments_model.dart';
import '../services/appointment_services.dart';

part 'appointment_state.dart';

class AppointmentCubit extends BaseCubit<AppointmentState> {
  final AppointmentServices service;

  AppointmentCubit({required this.service}) : super(const AppointmentState());

  Future<void> fetchAppointments() async {
    safeEmit(
      state.copyWith(status: EnumGeneralStateStatus.loading, message: null),
    );
    try {
      final res = await service.appointmentList();
      final summaries = (res.data ?? <AppointmentsModel>[])
          .map(
            (e) => AppointmentSummary(
              branchName: e.branchName,
              doctorName: e.doctorName,
            ),
          )
          .toList();
      MyLog.debug("appointments: ${res.data}");

      safeEmit(
        state.copyWith(status: EnumGeneralStateStatus.success, data: summaries),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.toString(),
          data: const [],
        ),
      );
    }
  }

  void clear() => safeEmit(const AppointmentState());
}
