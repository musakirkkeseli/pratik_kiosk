import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:kiosk/features/widget/custom_button.dart';

import '../../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../model/price_model.dart';
import 'price_info_card_widget.dart';

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
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: ConstColor.textfieldColor),
            // Text(patientTranscationProcessList!.processName ?? "-"),
            Row(
              spacing: 10,
              children: [
                Iconify(
                  MaterialSymbols.summarize_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 35,
                ),
                Text(
                  ConstantString().summaryAndInvoice,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 35,
                  ),
                ),
              ],
            ),
            Text(
              "Fatura No: 2023-00145",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 0,
                    child: Text(
                      "Açıklama",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Tutar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: Border.all(
                  color: ConstColor.textfieldColor,
                  width: 1.0,
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: patientTranscationDetList.length,
                itemBuilder: (context, index) {
                  GetPatientTranscationDet patientTranscationDet =
                      patientTranscationDetList[index];
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.01,
                      vertical: MediaQuery.of(context).size.width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      border: index < patientTranscationDetList.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: ConstColor.textfieldColor,
                                width: 1.0,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 0,
                          child: Text(
                            patientTranscationDet.associationName ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            patientTranscationDet.patTotalPrice ?? "-",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: ConstColor.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(
                child: Text(
                  "${ConstantString().totalAmount} : ${patientTranscationProcessList!.patientPrice ?? "-"}",
                  style: TextStyle(color: ConstColor.white),
                ),
              ),
            ),
            PriceInfoCardWidget(),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                label: ConstantString().paymentAction,
                onPressed: () {
                  context.read<PatientRegistrationProceduresCubit>().nextStep();
                },
              ),
            ),
          ],
        ),
      );
    }
    return Text(ConstantString().errorOccurred);
  }
}
