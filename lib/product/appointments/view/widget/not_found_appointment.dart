import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';

class NotFoundAppointment extends StatelessWidget {
  const NotFoundAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.23,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: ConstColor.grey400),
            const SizedBox(height: 16),
            Text(
              ConstantString().noAppointments,
              style: context.notFoundText.copyWith(
                fontWeight: FontWeight.w600,
                color: ConstColor.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
