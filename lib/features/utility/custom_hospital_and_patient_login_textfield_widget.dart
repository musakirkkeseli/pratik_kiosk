import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

class CustomHospitalAndPatientLoginTextfieldWidget extends StatelessWidget {
  final EnumTextformfield type;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  const CustomHospitalAndPatientLoginTextfieldWidget({
    super.key,
    required this.controller,
    this.onChanged,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: type.label, hintText: type.hint),
      obscureText: type.obscureText,
      keyboardType: type.keyboardType,
      inputFormatters: type.inputFormatters,
      maxLength: type.maxLength,
      validator: type.validator,
      onChanged: onChanged,
    );
  }
}
