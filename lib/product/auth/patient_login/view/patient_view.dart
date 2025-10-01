import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/product/auth/patient_login/services/patient_services.dart';

import '../../../../core/widget/snackbar_service.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_general_state_status.dart';
import '../../../../features/utility/tenant_http_service.dart';
import '../cubit/patient_login_cubit.dart';
import 'widget/patient_login_widget.dart';

class PatientView extends StatefulWidget {
  const PatientView({super.key});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientLoginCubit>(
      create: (context) =>
          PatientLoginCubit(service: PatientServices(TenantHttpService())),
      child: BlocConsumer<PatientLoginCubit, PatientLoginState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) async {
          switch (state.status) {
            case EnumGeneralStateStatus.failure:
              SnackbarService().showSnackBar(
                state.message ?? ConstantString().errorOccurred,
              );
              break;
            default:
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(ConstantString().patientLogin)),
            body: PatientLoginWidget(authType: state.authType),
          );
        },
      ),
    );
  }
}
