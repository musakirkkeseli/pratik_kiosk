import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../features/utility/const/constant_color.dart';
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
  final TextEditingController userNameController = kReleaseMode
      ? TextEditingController()
      : TextEditingController(text: "buhara");
  final TextEditingController passwordController = kReleaseMode
      ? TextEditingController()
      : TextEditingController(text: "buhara");

  LinearGradient get _verticalGradient => const LinearGradient(
    colors: [Color(0xFF6F0E0E), Color(0xFF040404)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: _verticalGradient),
        child: SizedBox.expand(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width * 0.78,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(120.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 48.0,
                vertical: 0.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 30,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ConstantString.hospitalLogo,
                      width: 100,
                      height: 150,
                    ),
                    CustomHospitalAndPatientLoginTextfieldWidget(
                      type: EnumTextformfield.hospitalUserName,
                      controller: userNameController,
                    ),

                    CustomHospitalAndPatientLoginTextfieldWidget(
                      type: EnumTextformfield.hospitalUserPassword,
                      controller: passwordController,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 10,
                        width: MediaQuery.of(context).size.width * (2 / 3),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            backgroundColor:
                                ConstColor.primaryHospitalLoginColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                          onPressed: () {
                            final isValid =
                                _formKey.currentState?.validate() ?? false;
                            if (isValid) {
                              FocusScope.of(context).unfocus();
                              context
                                  .read<HospitalLoginCubit>()
                                  .postHospitalLoginCubit(
                                    username: userNameController.text,
                                    password: passwordController.text,
                                  );
                            }
                          },
                          child: Text(
                            ConstantString().signIn,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
