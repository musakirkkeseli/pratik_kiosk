import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'const/constant_color.dart';

extension StringLocalization on String {
  String get locale => this.tr();

  localArg(List<String> args) {
    return this.tr(args: args);
  }
}

extension ConventerDateApi on DateFormat {
  String converterToDB(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
  }

  String converterToDate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  String converterToDateTR(DateTime dateTime) {
    return DateFormat("dd-MM-yyyy").format(dateTime);
  }

  DateTime fromStringToDateTime(String dateTimeString) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateTimeString);
  }
}

extension PageBackgroundDecoration on BoxDecoration {
  customLinearGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [ConstColor.primaryColor],
      ),
    );
  }
}
