import 'package:flutter/material.dart';

import 'environment.dart';

class ConstantString {
  static var backendUrl = Environment.backendUrl;
   String errorOccurred = "errorOccurred";


     // Localization
  // ignore: constant_identifier_names
  static const SUPPORTED_LOCALE = [
    ConstantString.TR_LOCALE,
    ConstantString.EN_LOCALE,
    ConstantString.AR_LOCALE
  ];
  static const TR_LOCALE = Locale("tr", "TR");
  static const EN_LOCALE = Locale('en', 'EN');
  static const AR_LOCALE = Locale('ar', 'AR');
  static const LANG_PATH = "assets/lang";
  static const turkish = "Türkçe";
  static const english = "English";
  static const arabic = "عربي";
}
