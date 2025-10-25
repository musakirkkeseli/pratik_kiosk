import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

class CustomInputContainer extends StatelessWidget {
  final EnumTextformfield type;
  final Widget child;
  final String? customLabel;

  const CustomInputContainer({
    super.key,
    required this.type,
    required this.child,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Text(
            customLabel ??
                type.label, // customLabel varsa onu kullan, yoksa enum'dan al
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(child: child),
        ),
      ],
    );
  }
}
