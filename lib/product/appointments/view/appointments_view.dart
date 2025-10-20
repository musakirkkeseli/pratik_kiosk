import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/user_http_service.dart';
import 'package:kiosk/product/appointments/services/appointment_services.dart';
import 'package:kiosk/product/appointments/view/widget/appointment_card.dart';

import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';

import '../cubit/appointment_cubit.dart';
import '../model/appointments_model.dart';

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
      child: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          return _body(state);
        },
      ),
    );
  }

  _body(AppointmentState state) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case EnumGeneralStateStatus.success:
        List<AppointmentsModel> appointmentList = state.data;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: appointmentList.length,
          itemBuilder: (_, i) {
            final AppointmentsModel appointment = appointmentList[i];
            return AppointmentCard(
              branchName: appointment.branchName ?? "",
              departmentName: appointment.departmentName ?? "",
              appointmentTime: appointment.appointmentTime ?? "",
              doctorName: appointment.doctorName ?? "",
            );
          },
        );
      default:
        return Center(
          child: Text(state.message ?? ConstantString().noAppointments),
        );
    }
  }
}
