import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ConstAppFunc {
  // Function that calculates the number of dates horizontally
  static int calculateRow(int elementCount, {int partCount=3}) {
    switch (elementCount) {
      case 0:
        return 0;
      default:
        if ((elementCount % partCount) == 0) {
          return (elementCount ~/ partCount);
        } else {
          return (elementCount ~/ partCount) + 1;
        }
    }
  }

  static String toShortString(String value, {int countCharacter = 8}){
    return value.length>countCharacter ? "${value.substring(0, countCharacter-3)}...": value;
  }
  
  static String currentLanguage(BuildContext context){
    Logger().d("mevcut dil biglisi için çalıştı ${context.locale.languageCode}");
    return context.locale.languageCode;
  }
}
