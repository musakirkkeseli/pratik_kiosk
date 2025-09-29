import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/navigation_service.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../../hospital_login/services/hospital_and_user_login_services.dart';
import '../cubit/patient_login_cubit.dart';
import 'widget/patient_login_widget.dart';

class PatientLoginView extends StatefulWidget {
  const PatientLoginView({super.key});

  @override
  State<PatientLoginView> createState() => _PatientLoginViewState();
}

class _PatientLoginViewState extends State<PatientLoginView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientLoginCubit>(
      create: (context) => PatientLoginCubit(
        service: HospitalAndUserLoginServices(TenantHttpService()),
      ),
      child: BlocConsumer<PatientLoginCubit, PatientLoginState>(
        listenWhen: (prev, curr) => prev.tcStatus != curr.tcStatus,
        listener: (context, state) async {
          if (state.tcStatus == EnumGeneralStateStatus.success) {
            NavigationService.ns.routeTo("DateOfBirthWidget");

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('TC doğrulandı.')));
          } else if (state.tcStatus == EnumGeneralStateStatus.failure) {
            SnackbarService().showSnackBar(
              state.message ?? ConstantString().errorOccurred,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(ConstantString().patientLogin)),
            body: PatientLoginWidget(),
          );
        },
      ),
    );
  }
}
