import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:kiosk/features/widget/custom_button.dart';

import '../../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../../features/model/patient_price_detail_model.dart';
import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../../../features/utility/extension/color_extension.dart';
import 'price_info_card_widget.dart';

class PriceSuccessWidget extends StatelessWidget {
  final List<PaymentContent> paymentContentList;
  final PatientContent? patientContent;
  const PriceSuccessWidget({
    super.key,
    required this.paymentContentList,
    required this.patientContent,
  });

  @override
  Widget build(BuildContext context) {
    if (patientContent is PatientContent) {
      return Center(
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: ConstColor.textfieldColor),
            Row(
              spacing: 10,
              children: [
                Iconify(
                  MaterialSymbols.summarize_rounded,
                  color: context.primaryColor,
                  size: 35,
                ),
                Text(
                  ConstantString().summaryAndInvoice,
                  style: context.pageTitle.copyWith(fontSize: 35),
                ),
              ],
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
                    flex: 7,
                    child: Text(
                      ConstantString().description,
                      style: context.cardTitle.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    flex: 20,
                    child: Text(
                      ConstantString().amount,
                      style: context.cardTitle.copyWith(fontSize: 16),
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
                itemCount: paymentContentList.length,
                itemBuilder: (context, index) {
                  PaymentContent paymentContent = paymentContentList[index];
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.01,
                      vertical: MediaQuery.of(context).size.width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      border: index < paymentContentList.length - 1
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
                          flex: 7,
                          child: Text(
                            paymentContent.paymentName ?? "",
                            textAlign: TextAlign.center,
                            style: context.bodyPrimary.copyWith(fontSize: 14),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Expanded(
                          flex: 20,
                          child: Text(
                            paymentContent.price.toString(),
                            textAlign: TextAlign.center,
                            style: context.cardTitle.copyWith(fontSize: 14),
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
                  "${ConstantString().totalAmount} : ${patientContent!.totalPrice ?? "-"}",
                  style: context.buttonText.copyWith(color: ConstColor.white),
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
                  context
                      .read<PatientRegistrationProceduresCubit>()
                      .paymentAction(paymentContentList, patientContent);
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
