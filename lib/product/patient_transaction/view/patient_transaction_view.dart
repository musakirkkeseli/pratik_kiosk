import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kiosk/features/utility/user_http_service.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';
import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';

import 'package:kiosk/product/patient_transaction/cubit/patient_transaction_cubit.dart';
import 'package:kiosk/product/patient_transaction/cubit/patient_transaction_state.dart';
import 'package:kiosk/product/patient_transaction/model/Patient_transaction_request_model.dart';
import 'package:kiosk/product/patient_transaction/service/patient_transaction_service.dart';

import 'package:kiosk/core/widget/loading_widget.dart';

import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';

class PatientTransactionView extends StatelessWidget {
  const PatientTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PatientTransactionCubit>(
      create: (context) => PatientTransactionCubit(
        service: PatientTransactionService(UserHttpService()),
      )..fetchAssociations(),
      child: BlocBuilder<PatientTransactionCubit, PatientTransactionState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(ConstantString().homePageTitle)),
            body: _bodyFunc(state, context),
          );
        },
      ),
    );
  }

  Widget _bodyFunc(PatientTransactionState state, BuildContext context) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return const LoadingWidget();

      case EnumGeneralStateStatus.success:
        final List<AssociationsModel> items = state.data;
        if (items.isEmpty) {
          return Center(child: Text(ConstantString().noAppointments));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final item = items[i];
            return ListTile(
              title: Text(item.associationName ?? '-'),
              onTap: () {
                context
                    .read<PatientRegistrationProceduresCubit>()
                    .selectAssociation(
                      AssociationsModel(
                        associationId: item.associationId,
                        associationName: item.associationName,
                      ),
                    );
              },
            );
          },
        );

      default:
        return Center(
          child: Text(state.message ?? ConstantString().errorOccurred),
        );
    }
  }
}
