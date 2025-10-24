import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:kiosk/product/results/view/results_view.dart';

import '../../../product/appointments/view/appointments_view.dart';
import '../../../product/home/view/widget/section_button_widget.dart';
import '../const/constant_string.dart';
import '../extension/color_extension.dart';

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
        return Iconify(
          MaterialSymbols.calendar_month_outline_rounded,
          color: context.primaryColor,
        );
      case EnumHomeItem.registration:
        return Iconify(
          MaterialSymbols.holiday_village_rounded,
          color: context.primaryColor,
        );
      case EnumHomeItem.results:
        return Iconify(
          MaterialSymbols.view_list,
          color: context.primaryColor,
        );
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
