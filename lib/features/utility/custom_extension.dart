import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension StringLocalization on String {
  String get locale => this.tr();

  localArg(List<String> args) {
    return this.tr(args: args);
  }
}

extension HexColor on String {
  Color toColor() {
    final hex = replaceAll("#", this);
    return Color(int.parse("0xFF$hex"));
  }
}
