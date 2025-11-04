import 'package:flutter/material.dart';

import '../../../features/model/patient_price_detail_model.dart';
import 'widget/price_success_widget.dart';

class PriceView extends StatelessWidget {
  final List<PaymentContent> paymentContentList;
  final PatientContent? patientContent;
  const PriceView({
    super.key,
    required this.paymentContentList,
    required this.patientContent,
  });

  @override
  Widget build(BuildContext context) {
    return PriceSuccessWidget(
      paymentContentList: paymentContentList,
      patientContent: patientContent,
    );
  }
}
