import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/navigation_service.dart';
import '../../../features/utility/user_http_service.dart';
import '../../../features/widget/app_dialog.dart';
import '../cubit/price_details_cubit.dart';
import '../service/price_details_service.dart';
import 'widget/price_success_widget.dart';

class PriceView extends StatelessWidget {
  final String patientId;
  const PriceView({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PriceDetailsCubit(
        service: PriceDetailsService(UserHttpService()),
        patientId: patientId, //"4352273"
      )..fetchPatientPrice(),
      child: BlocConsumer<PriceDetailsCubit, PriceDetailsState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) async {
          switch (state.status) {
            case EnumGeneralStateStatus.failure:
              await context
                  .read<PatientRegistrationProceduresCubit>()
                  .patientTransactionCancel();
              NavigationService.ns.goBack();
              AppDialog(context).infoDialog(
                "Kayıt İşlemi Başarısız Oldu",
                "Lütfen bankoya müracaat edin",
              );
              break;
            default:
          }
        },
        builder: (context, state) {
          return _body(state, context);
        },
      ),
    );
  }

  _body(PriceDetailsState state, BuildContext context) {
    switch (state.status) {
      case EnumGeneralStateStatus.success:
        return PriceSuccessWidget(
          paymentContentList: state.paymentContentList ?? [],
          patientContent: state.patientContent,
        );
      default:
        return Center(child: CircularProgressIndicator());
    }
  }
}
