import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/user_http_service.dart';
import 'package:kiosk/product/appointments/services/appointment_services.dart';
import 'package:kiosk/product/appointments/view/widget/appointment_card.dart';

import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../features/utility/navigation_service.dart';
import '../../ patient_registration_procedures/model/patient_registration_procedures_request_model.dart';
import '../cubit/appointment_cubit.dart';
import '../model/appointments_model.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        return const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        );
      case EnumGeneralStateStatus.success:
        List<AppointmentsModel> appointmentList = state.data;
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.23,
              child: Stack(
                children: [
                  Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 10.0,
                    radius: const Radius.circular(6),
                    trackVisibility: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        right: 50,
                        top: 8,
                        bottom: 8,
                        left: 8,
                      ),
                      itemCount: appointmentList.length,
                      itemBuilder: (_, i) {
                        final AppointmentsModel appointment =
                            appointmentList[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: AppointmentCard(
                            branchName: appointment.branchName ?? "",
                            departmentName: appointment.departmentName ?? "",
                            appointmentTime: appointment.appointmentTime ?? "",
                            doctorName: appointment.doctorName ?? "",
                            onTap: () {
                              NavigationService.ns.routeTo(
                                "PatientRegistrationProceduresView",
                                arguments: {
                                  "startStep": EnumPatientRegistrationProcedures
                                      .patientTransaction,
                                  "model": PatientRegistrationProceduresModel(
                                    branchId: int.tryParse(
                                      appointment.branchID ?? "",
                                    ),
                                    departmentId: int.tryParse(
                                      appointment.departmentID ?? "",
                                    ),
                                    branchName: appointment.branchName,
                                    doctorId: int.tryParse(
                                      appointment.doctorID ?? "",
                                    ),
                                    doctorName: appointment.doctorName,
                                    appointmentId: appointment.appointmentID,
                                  ),
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (appointmentList.length > 1)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 50,
                      child: IgnorePointer(
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.white.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      default:
        return SizedBox(
          height: 200,
          child: Center(
            child: Text(state.message ?? ConstantString().noAppointments),
          ),
        );
    }
  }
}
