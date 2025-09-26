import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

import '../../../../../features/utility/const/constant_string.dart';
import '../../../../../features/utility/custom_hospital_and_patient_login_textfield_widget.dart';
import '../../cubit/patient_login_cubit.dart';

class PatientLoginWidget extends StatefulWidget {
  const PatientLoginWidget({super.key});

  @override
  State<PatientLoginWidget> createState() => _PatientLoginWidgetState();
}

class _PatientLoginWidgetState extends State<PatientLoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tcController = TextEditingController();

  @override
  void dispose() {
    _tcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomHospitalAndPatientLoginTextfieldWidget(
              type: EnumTextformfield.tc,
              controller: _tcController,
            ),
            ElevatedButton.icon(
              onPressed: () {
                final isValid = _formKey.currentState?.validate() ?? false;
                if (isValid) {
                  FocusScope.of(context).unfocus();
                  context.read<PatientLoginCubit>().verifyPatientTcCubit(
                    tcNo: _tcController.text.trim(),
                  );
                }
              },
              label: Text(ConstantString().signIn),
            ),
          ],
        ),
      ),
    );
  }
}
