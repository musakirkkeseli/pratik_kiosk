import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../product/auth/login/cubit/hospital_login_cubit.dart';
import '../../product/auth/login/view/hospital_login_view.dart';
import '../../product/auth/login/view/widget/date_of_birth_widget.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "DateOfBirthWidget":
        // final args = settings.arguments as Map? ?? {};
        return MaterialPageRoute(
          builder: (context) => DateOfBirthWidget(),
          settings: RouteSettings(name: settings.name),
        );
      case "PatientLoginView":
        final cubit = settings.arguments as HospitalLoginCubit?;
        if (cubit == null) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(),
            settings: RouteSettings(name: settings.name),
          );
        }
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(value: cubit, child: const PatientLoginView()),
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
