import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/inactivity_controller.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  void initState() {
    final inactivity = context.read<InactivityController>();
    inactivity.bump(customTimeout: Duration(seconds: 50));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(child: Text("Ödeme Ekranı")),
          Container(child: Lottie.asset(ConstantString.posGif, width:500,height: 500,fit: BoxFit.contain)),
          Text("Ödeme Bekleniyor"),
        ],
      ),
    );
  }
}
