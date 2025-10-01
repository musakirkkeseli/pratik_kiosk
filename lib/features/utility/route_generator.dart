import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/product/appointments/view/appointments_view.dart';

import '../../product/auth/hospital_login/cubit/hospital_login_cubit.dart';
import '../../product/auth/patient_login/view/patient_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "AppointmentsView":
        // final args = settings.arguments as Map? ?? {};
        return MaterialPageRoute(
          builder: (context) => AppointmentsView(),
          settings: RouteSettings(name: settings.name),
        );
      case "PatientView":
        final cubit = settings.arguments as HospitalLoginCubit?;
        if (cubit == null) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(),
            settings: RouteSettings(name: settings.name),
          );
        }
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(value: cubit, child: const PatientView()),
          settings: RouteSettings(name: settings.name),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(),
          settings: RouteSettings(name: settings.name),
        );
    }
  }
}
