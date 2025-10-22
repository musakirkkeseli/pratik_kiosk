import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/core/utility/logger_service.dart';
import 'package:lottie/lottie.dart';

import '../../ patient_registration_procedures/cubit/patient_registration_procedures_cubit.dart';
import '../../../features/model/patient_price_detail_model.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/inactivity_controller.dart';

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
      MyLog.debug("Ödeme gönderildi");
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
        children: [
          Center(child: Text("Ödeme Ekranı")),
          Container(
            child: Lottie.asset(
              ConstantString.posGif,
              width: 500,
              height: 500,
              fit: BoxFit.contain,
            ),
          ),
          Text("Ödeme Bekleniyor"),
        ],
      ),
    );
  }
}
