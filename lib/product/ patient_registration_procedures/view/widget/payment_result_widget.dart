import 'package:flutter/material.dart';

import '../../../../features/utility/enum/enum_payment_result_type.dart';

class PaymentResultWidget extends StatelessWidget {
  final EnumPaymentResultType paymentResultType;
  const PaymentResultWidget({super.key, required this.paymentResultType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Ödeme Sonucu ${paymentResultType.title}")],
      ),
    );
  }
}
