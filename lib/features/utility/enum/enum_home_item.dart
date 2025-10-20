import 'package:flutter/material.dart';
import 'package:kiosk/product/results/view/results_view.dart';

import '../../../product/appointments/view/appointments_view.dart';
import '../../../product/home/view/widget/section_button_widget.dart';
import '../const/constant_string.dart';

enum EnumHomeItem {
  appointments,
  registration,
  results;

  String get label {
    switch (this) {
      case EnumHomeItem.appointments:
        return ConstantString().appointmentRegistration;
      case EnumHomeItem.registration:
        return ConstantString().registration;
      case EnumHomeItem.results:
        return ConstantString().tests;
    }
  }

  Widget icon(BuildContext context) {
    switch (this) {
      case EnumHomeItem.appointments:
        return Icon(Icons.calendar_today, color: Theme.of(context).primaryColor);
      case EnumHomeItem.registration:
        return Icon(Icons.person_add, color: Theme.of(context).primaryColor);
      case EnumHomeItem.results:
        return Icon(Icons.assignment, color: Theme.of(context).primaryColor);
    }
  }

  Widget widget() {
    switch (this) {
      case EnumHomeItem.appointments:
        return AppointmentsView();
      case EnumHomeItem.registration:
        return SectionButtonWidget();
      case EnumHomeItem.results:
        return ResultsView();
    }
  }
}
