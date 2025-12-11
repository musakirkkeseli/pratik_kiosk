import 'package:flutter/material.dart';

import '../const/constant_color.dart';
import '../const/constant_string.dart';

enum EnumPaymentResultType {
  success,
  failure;

  String get title {
    switch (this) {
      case EnumPaymentResultType.success:
        return ConstantString().paymentSuccess;
      case EnumPaymentResultType.failure:
        return ConstantString().paymentFailure;
    }
  }

  MaterialColor get color {
    switch (this) {
      case EnumPaymentResultType.success:
        return ConstColor.green;
      case EnumPaymentResultType.failure:
        return ConstColor.red;
    }
  }

  String get description {
    switch (this) {
      case EnumPaymentResultType.success:
        return ConstantString().paymentCompletedSuccessfully;
      case EnumPaymentResultType.failure:
        return ConstantString().paymentCompletedFailed;
    }
  }

  String get message {
    switch (this) {
      case EnumPaymentResultType.success:
        return ConstantString().examinationRegistrationCreated;
      case EnumPaymentResultType.failure:
        return ConstantString().requirePaymentForExaminationRegistration;
    }
  }
}
