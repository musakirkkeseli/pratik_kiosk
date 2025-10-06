import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utility/const/constant_string.dart';

class AppDialog {
  late BuildContext context;
  AppDialog(this.context);

  Future<dynamic> loadingDialog() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        child: WillPopScope(
          child: Center(child: Lottie.asset(ConstantString.healthGif, width: 150)),
          onWillPop: () async => false,
        ),
      ),
    );
  }
}
