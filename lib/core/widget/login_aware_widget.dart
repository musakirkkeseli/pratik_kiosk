import 'package:flutter/material.dart';
import 'package:kiosk/product/home/view/home_view.dart';
import 'package:provider/provider.dart';

import '../../product/auth/hospital_login/view/hospital_login_view.dart';
import '../../product/auth/patient_login/view/patient_view.dart';
import '../utility/login_status_service.dart';
import '../utility/user_login_status_service.dart';

class LoginAwareWidget extends StatelessWidget {
  const LoginAwareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStatus>(
      builder: (context, data, child) {
        return data == LoginStatus.online
            ? Consumer<UserLoginStatus>(
                builder: (context, data2, child) {
                  return data2 == UserLoginStatus.online
                      ? HomeView()
                      : PatientView();
                },
              )
            : HospitalLoginView();
      },
    );
  }
}
