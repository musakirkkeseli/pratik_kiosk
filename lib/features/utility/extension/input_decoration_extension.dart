import 'package:flutter/material.dart';

extension ExtensionInputDecoration on InputDecoration {
  InputDecoration get mandatoryDecoration => InputDecoration(
    fillColor: Colors.grey.shade200,
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
