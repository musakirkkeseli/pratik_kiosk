import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../../features/utility/navigation_service.dart';

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
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: () {
          NavigationService.ns.routeTo(
            "PatientRegistrationProceduresView",
            arguments: {"startStep": EnumPatientRegistrationProcedures.section},
          );
        },
        child: Center(
          child: Text(
            ConstantString().branches,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
