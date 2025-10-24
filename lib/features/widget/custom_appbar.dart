import 'package:flutter/material.dart';

import '../utility/const/constant_string.dart';
import '../utility/extension/color_extension.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(color: context.primaryColor),
      child: Column(
        children: [
          Image.asset(ConstantString.buharaLogo, width: 200, height: 200),
        ],
      ),
    );
  }
}
