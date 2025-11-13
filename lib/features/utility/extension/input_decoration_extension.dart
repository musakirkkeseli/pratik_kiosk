import 'package:flutter/material.dart';

import '../const/constant_color.dart';

extension ExtensionInputDecoration on InputDecoration {
  InputDecoration get mandatoryDecoration => InputDecoration(
    fillColor: ConstColor.grey200,
    filled: false,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    counterText: '',
  );
}
