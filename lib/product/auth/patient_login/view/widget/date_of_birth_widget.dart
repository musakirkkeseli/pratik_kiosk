import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

import '../../../../../features/utility/const/constant_string.dart';
import '../../../../../features/utility/custom_hospital_and_patient_login_textfield_widget.dart';

class DateOfBirthWidget extends StatefulWidget {
  const DateOfBirthWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DateOfBirthWidgetState createState() => _DateOfBirthWidgetState();
}

class _DateOfBirthWidgetState extends State<DateOfBirthWidget> {
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ConstantString().birthDate)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            CustomHospitalAndPatientLoginTextfieldWidget(
              controller: _dobController,
              type: EnumTextformfield.birthday,
            ),

            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              width: double.infinity,
              // child: ElevatedButton(
              //   onPressed: ,
              //   child: const Text('Giriş Yap'),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
