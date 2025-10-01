import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';

import '../../../core/utility/user_login_status_service.dart';
import '../../appointments/view/appointments_view.dart';
import 'widget/section_button_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(ConstantString().home),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              UserLoginStatusService().logout();
            },
            child: Text(ConstantString().logout),
          ),
        ],
      ),
      body: Column(children: [
        AppointmentsView(),
         SectionButtonWidget()
        ]),
    );
  }
}
