import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

import '../../../../../features/utility/const/constant_string.dart';
import '../../../../../features/utility/custom_hospital_and_patient_login_textfield_widget.dart';
import '../../cubit/patient_login_cubit.dart';
import '../../model/patient_register_request_model.dart';

class PatientLoginWidget extends StatefulWidget {
  final AuthType authType;
  const PatientLoginWidget({super.key, required this.authType});

  @override
  State<PatientLoginWidget> createState() => _PatientLoginWidgetState();
}

class _PatientLoginWidgetState extends State<PatientLoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();

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
            if (widget.authType == AuthType.register)
              CustomHospitalAndPatientLoginTextfieldWidget(
                controller: _birthDayController,
                type: EnumTextformfield.birthday,
              ),

            ElevatedButton.icon(
              onPressed: () {
                final isValid = _formKey.currentState?.validate() ?? false;
                if (isValid) {
                  FocusScope.of(context).unfocus();
                  final state = context.read<PatientLoginCubit>().state;

                  state.authType == AuthType.login
                      ? context.read<PatientLoginCubit>().userLogin(
                          tcNo: _tcController.text.trim(),
                        )
                      : context.read<PatientLoginCubit>().userRegister(
                          patientRegisterRequestModel:
                              PatientRegisterRequestModel(
                                tcNo: _tcController.text.trim(),
                                birthDate: _birthDayController.text.trim(),
                              ),
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
