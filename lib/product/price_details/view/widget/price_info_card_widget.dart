import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../../../features/utility/extension/color_extension.dart';

class PriceInfoCardWidget extends StatelessWidget {
  const PriceInfoCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.14,
          decoration: BoxDecoration(
            color: ConstColor.infoCardColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 2, color: ConstColor.textfieldColor),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
              horizontal: MediaQuery.of(context).size.height * 0.02,
            ),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Iconify(
                          Bi.credit_card_2_front_fill,
                          size: 10,
                          color: ConstColor.white,
                        ),
                      ),
                    ),
                    Text(
                      ConstantString().creditCardPayment,
                      style: context.sectionTitle.copyWith(fontSize: 30),
                    ),
                  ],
                ),
                Text(
                  ConstantString().securePaymentMessage,
                  style: context.bodyPrimary.copyWith(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
