import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/user_http_service.dart';
import 'package:kiosk/product/appointments/services/appointment_services.dart';

import '../../../core/utility/user_login_status_service.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../cubit/appointment_cubit.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AppointmentCubit(service: AppointmentServices(UserHttpService()))
            ..fetchAppointments(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Randevular")),
        body: BlocBuilder<AppointmentCubit, AppointmentState>(
          builder: (context, state) {
            switch (state.status) {
              case EnumGeneralStateStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case EnumGeneralStateStatus.success:
                if (state.data.isEmpty) {
                  Text("succes");
                  context.read<AppointmentCubit>().fetchAppointments();
                }
                UserLoginStatusService().logout();
                return ListView.separated(
                  itemCount: state.data.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final AppointmentSummary appointmentSummary = state.data[i];
                    return ListTile(
                      title: Text(appointmentSummary.branchName ?? '-'),
                      subtitle: Text(appointmentSummary.doctorName ?? '-'),
                    );
                  },
                );
              default:
                return Center(child: Text("asdadasd"));
            }
          },
        ),
      ),
    );
  }
}
