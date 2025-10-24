import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk/features/utility/custom_input_container.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

class CustomTextfieldWidget extends StatelessWidget {
  final EnumTextformfield type;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? customValidator;
  final int? customMaxLength;
  final List<TextInputFormatter>? customInputFormatters;
  final String? customLabel; // Dinamik label için

  const CustomTextfieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSaved,
    this.customValidator,
    this.customMaxLength,
    this.customInputFormatters,
    this.customLabel,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInputContainer(
      type: type,
      customLabel: customLabel,
      child: TextFormField(
        controller: controller,
        obscureText: type.obscureText,
        keyboardType: type.keyboardType,
        inputFormatters: customInputFormatters ?? type.inputFormatters,
        maxLength: customMaxLength ?? type.maxLength,
        validator: customValidator ?? type.validator,
        onChanged: onChanged,
        onSaved: onSaved,
        style: const TextStyle(fontSize: 25),
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          counterText: '', // maxLength sayacını kaldırır
        ),
      ),
    );
  }
}
