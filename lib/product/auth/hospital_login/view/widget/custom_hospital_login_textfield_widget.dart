import 'package:flutter/material.dart';

class CustomHospitalLoginTextfieldWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const CustomHospitalLoginTextfieldWidget({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        labelText: labelText,
      ),
    );
  }
}
