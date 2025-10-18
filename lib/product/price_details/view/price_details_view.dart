import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/user_http_service.dart';
import 'package:kiosk/product/price_details/service/price_details_service.dart';

import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../cubit/price_details_cubit.dart';

class PriceView extends StatelessWidget {
  const PriceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PriceDetailsCubit(
        service: PriceDetailsService(UserHttpService()),
        patientId: "4352273",
      )..fetchPatientPrice(),
      child: BlocBuilder<PriceDetailsCubit, PriceDetailsState>(
        builder: (context, state) {
          return _body(state, context);
        },
      ),
    );
  }

  _body(PriceDetailsState state, BuildContext context) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return Center(child: CircularProgressIndicator());
      case EnumGeneralStateStatus.success:
        return Center(
          child: Column(
            children: [
              Text(ConstantString().priceInformation),
              Text(state.patientTranscationProcessList!.processName ?? "-"),
              Text(state.patientTranscationProcessList!.patientPrice ?? "-"),
              ElevatedButton(
                onPressed: () {
                  context.read<PatientRegistrationProceduresCubit>().nextStep();
                },
                child: Text(ConstantString().paymentAction),
              ),
            ],
          ),
        );
      default:
        return Center(child: Text(ConstantString().errorOccurred));
    }
  }
}
