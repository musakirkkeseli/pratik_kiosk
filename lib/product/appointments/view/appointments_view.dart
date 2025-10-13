import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/user_http_service.dart';
import 'package:kiosk/product/appointments/services/appointment_services.dart';

import '../../ patient_registration_procedures/model/patient_registration_procedures_request_model.dart';
import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../features/utility/navigation_service.dart';
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
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: ConstColor.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        ConstantString().appointments,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 2,
                        color: ConstColor.primaryColor,
                      ),
                      _body(state),
                    ],
                  ),
                ),
              ],
            ),
          );
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
        return Expanded(
          child: ListView.separated(
            itemCount: appointmentList.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final AppointmentsModel appointment = appointmentList[i];
              return ListTile(
                onTap: () {
                  NavigationService.ns.routeTo(
                    "PatientRegistrationProceduresView",
                    arguments: {
                      "startStep":
                          EnumPatientRegistrationProcedures.patientTransaction,
                      "model": PatientRegistrationProceduresRequestModel(
                        branchId: int.tryParse(appointment.branchID ?? ""),
                        departmentId: int.tryParse(appointment.departmentID ?? ""),
                        branchName: appointment.branchName,
                        doctorId: int.tryParse(appointment.doctorID ?? ""),
                        doctorName: appointment.doctorName,
                      ),
                    },
                  );
                },
                title: Text(appointment.branchName ?? '-'),
                subtitle: Text(appointment.doctorName ?? '-'),
              );
            },
          ),
        );
      default:
        return Center(
          child: Text(state.message ?? ConstantString().noAppointments),
        );
    }
  }
}
