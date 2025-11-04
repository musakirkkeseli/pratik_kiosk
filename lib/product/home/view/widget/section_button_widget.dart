import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../../features/utility/navigation_service.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';

class SectionButtonWidget extends StatefulWidget {
  const SectionButtonWidget({super.key});

  @override
  State<SectionButtonWidget> createState() => _SectionButtonWidgetState();
}

class _SectionButtonWidgetState extends State<SectionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.90,
      height: MediaQuery.of(context).size.height * 0.08,

      child: ElevatedButton(
        onPressed: () {
          NavigationService.ns.routeTo(
            "PatientRegistrationProceduresView",
            arguments: {"startStep": EnumPatientRegistrationProcedures.section},
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Iconify(
                    Teenyicons.calendar_minus_solid,
                    color: ConstColor.white,
                    size: 35,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    ConstantString().selectDepartment,
                    style: context.buttonText.copyWith(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
