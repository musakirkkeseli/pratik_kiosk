import 'package:flutter/material.dart';
import 'package:kiosk/product/auth/hospital_login/view/hospital_login_view.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../utility/login_status_service.dart';

//kullanıcının uygulamaya giriş yapıp yapmadığı durumunu dinler ve
//eğer giriş yaptıysa onlineChild eğer giriş yapmadıysa offlineChild widgetlerini döndürür
class LoginAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const LoginAwareWidget({
    Key? key,
    required this.onlineChild,
    required this.offlineChild, required HospitalLoginView child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginStatus>(
      builder: (context, data, child) {
        return data == LoginStatus.online ? onlineChild : offlineChild;
      },
    );
  }
}
