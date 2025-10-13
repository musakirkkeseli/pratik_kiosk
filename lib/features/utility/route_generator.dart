import 'package:flutter/material.dart';
import 'package:kiosk/product/appointments/view/appointments_view.dart';

import '../../core/widget/login_aware_widget.dart';
import '../../product/ patient_registration_procedures/view/patient_registration_procedures_view.dart';
import '../../product/patient_transaction/view/patient_transaction_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) => LoginAwareWidget(),
          settings: RouteSettings(name: settings.name),
        );
      case "AppointmentsView":
        return MaterialPageRoute(
          builder: (context) => AppointmentsView(),
          settings: RouteSettings(name: settings.name),
        );
      case "PatientRegistrationProceduresView":
        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => PatientRegistrationProceduresView(
            startStep: args["startStep"],
            model: args["model"],
          ),
          settings: RouteSettings(name: settings.name),
        );
      // case "SectionSearchView":
      //   return MaterialPageRoute(
      //     builder: (context) => SectionSearchView(),
      //     settings: RouteSettings(name: settings.name),
      //   );
      // case "DoctorSearchView":
      //   final args = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (context) =>
      //         DoctorSearchView(sectionId: args["sectionId"] ?? 0),
      //     settings: RouteSettings(name: settings.name),
      //   );
      case "PatientTransactionView":
        return MaterialPageRoute(
          builder: (context) => PatientTransactionView(),
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
