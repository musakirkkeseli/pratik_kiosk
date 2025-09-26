import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/utility/const/constant_string.dart';
import '../../../../../features/utility/custom_hospital_and_patient_login_textfield_widget.dart';
import '../../../../../features/utility/enum/enum_textformfield.dart';
import '../../cubit/hospital_login_cubit.dart';

class HospitalLoginWidget extends StatefulWidget {
  const HospitalLoginWidget({super.key});

  @override
  State<HospitalLoginWidget> createState() => _HospitalLoginWidgetState();
}

class _HospitalLoginWidgetState extends State<HospitalLoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHospitalAndPatientLoginTextfieldWidget(
              type: EnumTextformfield.hospitalUserName,
              controller: userNameController,
            ),
            const SizedBox(height: 16.0),
            CustomHospitalAndPatientLoginTextfieldWidget(
              type: EnumTextformfield.hospitalUserPassword,

              controller: passwordController,
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final isValid = _formKey.currentState?.validate() ?? false;
                  if (isValid) {
                    FocusScope.of(context).unfocus();
                    context.read<HospitalLoginCubit>().postUserLoginCubit(
                      username: userNameController.text,
                      password: passwordController.text,
                    );
                  }
                },
                child: Text(ConstantString().signIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
