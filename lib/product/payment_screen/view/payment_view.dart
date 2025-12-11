import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../features/model/patient_price_detail_model.dart';
import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/inactivity_controller.dart';
import '../../../features/utility/extension/text_theme_extension.dart';

class PaymentView extends StatefulWidget {
  final PatientTransactionDetailsResponseModel patientPriceDetailModel;
  const PaymentView({super.key, required this.patientPriceDetailModel});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String totalAmount = "";
  InactivityController? _inactivityController;

  @override
  void initState() {
    super.initState();
    totalAmount =
        widget.patientPriceDetailModel.patientContent?.totalPrice ?? "0";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // InactivityController referansını güvenli bir şekilde kaydet
    if (_inactivityController == null) {
      _inactivityController = context.read<InactivityController>();
      _inactivityController?.pause(); // POS ödeme sırasında timer'ı durdur
    }
  }

  @override
  void dispose() {
    // Kaydedilmiş referansı kullan, context'e tekrar erişme
    _inactivityController?.resume(); // Ekran kapandığında timer'ı yeniden başlat
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          children: [
            Text(
              ConstantString().paymentProcessing,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontSize: 20),
            ),
            Lottie.asset(
              ConstantString.paymentLoading,
              width: 150,
              height: 50,
              fit: BoxFit.contain,
            ),
            Lottie.asset(
              ConstantString.posGif,
              width: 500,
              height: 500,
              fit: BoxFit.cover,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: ConstColor.textfieldColor, width: 2),
                color: ConstColor.infoCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ConstantString().paymentAmount,
                    style: context.cardTitle,
                  ),
                  Text(
                    "$totalAmount ₺",
                    style: context.sectionTitle.copyWith(fontSize: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
