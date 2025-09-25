import 'package:flutter/material.dart';
import 'package:kiosk/product/auth/login/view/hospital_login_view.dart';

import 'features/utility/app_initialize.dart';
import 'features/utility/navigation_service.dart';
import 'features/utility/route_generator.dart';

Future<void> main() async {
  await AppInitialize.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const HospitalLoginView(),
      onGenerateRoute: RouteGenerator.generateRoutes,
      navigatorKey: NavigationService.ns.navigatorKey,
      navigatorObservers: [NavigationService.ns],
    );
  }
}
