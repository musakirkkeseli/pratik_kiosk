import 'package:flutter/material.dart';

import '../utility/extension/text_theme_extension.dart';
import '../utility/extension/color_extension.dart';

class ItemButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ItemButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Ink(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            width: 2,
            color: context.primaryColor.withOpacity(0.3),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.cardTitle,
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: context.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
