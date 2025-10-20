import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../model/price_model.dart';

class PriceSuccessWidget extends StatelessWidget {
  final GetPatientTranscationProcessList? patientTranscationProcessList;
  final List<GetPatientTranscationDet> patientTranscationDetList;
  const PriceSuccessWidget({
    super.key,
    required this.patientTranscationProcessList,
    required this.patientTranscationDetList,
  });

  @override
  Widget build(BuildContext context) {
    if (patientTranscationProcessList is GetPatientTranscationProcessList) {
      return Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<PatientRegistrationProceduresCubit>().nextStep();
              },
              child: Text(ConstantString().paymentAction),
            ),
            Text(patientTranscationProcessList!.processName ?? "-"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: patientTranscationDetList.length,
              itemBuilder: (context, index) {
                GetPatientTranscationDet patientTranscationDet =
                    patientTranscationDetList[index];
                return ListTile(
                  title: Text(patientTranscationDet.associationName ?? ""),
                  trailing: Text(patientTranscationDet.patTotalPrice ?? "-"),
                );
              },
            ),
            ListTile(
              title: Text(ConstantString().total),
              trailing: Text(
                patientTranscationProcessList!.patientPrice ?? "-",
              ),
            ),
          ],
        ),
      );
    }
    return Text(ConstantString().errorOccurred);
  }
}
