import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../features/utility/enum/enum_payment_result_type.dart';
import '../../../features/utility/user_http_service.dart';
import '../cubit/patient_registration_procedures_cubit.dart';
import '../model/patient_registration_procedures_request_model.dart';
import '../service/patient_registration_procedures_service.dart';
import 'widget/payment_result_widget.dart';
import 'widget/procedures_widget.dart';

class PatientRegistrationProceduresView extends StatelessWidget {
  final EnumPatientRegistrationProcedures startStep;
  final PatientRegistrationProceduresModel? model;
  const PatientRegistrationProceduresView({
    super.key,
    required this.startStep,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientRegistrationProceduresCubit(
        service: PatientRegistrationProceduresService(UserHttpService()),
        startStep: startStep,
        model: model,
      ),
      child:
          BlocConsumer<
            PatientRegistrationProceduresCubit,
            PatientRegistrationProceduresState
          >(
            listener: (context, state) {
              switch (state.status) {
                case EnumGeneralStateStatus.loading:
                  // AppDialog(context).loadingDialog();
                  break;
                case EnumGeneralStateStatus.success:
                  // NavigationService.ns.goBack();
                  break;
                case EnumGeneralStateStatus.failure:
                  // NavigationService.ns.goBack();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message ?? 'Error')),
                  );
                  break;
                default:
              }
            },
            builder: (context, state) {
              return Scaffold(body: _body(context, state));
            },
          ),
    );
  }


  _body(BuildContext context, PatientRegistrationProceduresState state) {
    if (state.paymentResultType is EnumPaymentResultType) {
      return PaymentResultWidget(
        paymentResultType: state.paymentResultType!,
        totalAmount: state.totalAmount,
      );
    }
    return ProceduresWidget(
      iColor: Colors.grey.shade300,
      aColor: Theme.of(context).colorScheme.primary,
      textTheme: Theme.of(context).textTheme,
      startStep: startStep,
      currentStep: state.currentStep,
      model: state.model,

    );
  }
}
