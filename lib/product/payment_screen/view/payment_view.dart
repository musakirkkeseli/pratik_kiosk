import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lottie/lottie.dart';

import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../features/model/patient_price_detail_model.dart';
import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/inactivity_controller.dart';
import '../../../features/utility/extension/text_theme_extension.dart';

class PaymentView extends StatefulWidget {
  final PatientPriceDetailModel patientPriceDetailModel;
  const PaymentView({super.key, required this.patientPriceDetailModel});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  void initState() {
    final inactivity = context.read<InactivityController>();
    inactivity.bump(customTimeout: Duration(seconds: 50));
    Future.delayed(Duration(seconds: 5), () {
      context
          .read<PatientRegistrationProceduresCubit>()
          .patientTransactionRevenue(widget.patientPriceDetailModel);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: 20,
        children: [
          Center(child: Text(ConstantString().paymentPending, style: context.sectionTitle)),
          Text(ConstantString().paymentProcessing, style: context.bodyPrimary),
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
                Text(ConstantString().paymentAmount, style: context.cardTitle),
                Text("1420,00 TL", style: context.sectionTitle.copyWith(fontSize: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
