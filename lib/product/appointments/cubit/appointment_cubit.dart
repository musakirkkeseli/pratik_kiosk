import 'package:meta/meta.dart';

import '../../../core/utility/base_cubit.dart';
import '../model/appointments_model.dart';
import '../services/appointment_services.dart';

part 'appointment_state.dart';

class AppointmentCubit extends BaseCubit<AppointmentState> {
  final AppointmentServices service;

  AppointmentCubit({required this.service}) : super(const AppointmentState());

  Future<void> fetchAppointments() async {
    safeEmit(state.copyWith(status: AppointmentStatus.loading, message: null));
    try {
      final res = await service.appointmentList(); // ApiResponse<List<AppointmentsModel>>
      final summaries = (res.data ?? <AppointmentsModel>[])
          .map((e) => AppointmentSummary(
                branchName: e.branchName,
                doctorName: e.doctorName,
              ))
          .toList();

      safeEmit(state.copyWith(
        status: AppointmentStatus.success,
        data: summaries,
      ));
    } catch (e) {
      safeEmit(state.copyWith(
        status: AppointmentStatus.failure,
        message: e.toString(),
        data: const [],
      ));
    }
  }

  void clear() => safeEmit(const AppointmentState());
}
