import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? trailingIcon;
  final Color? borderColor;
  final Color? textColor;
  final double? height;

  const ItemButton({
    super.key,
    required this.title,
    required this.onTap,
    this.trailingIcon = Icons.arrow_forward_ios,
    this.borderColor,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height ?? MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              width: 2,
              color: borderColor ?? Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor ?? Colors.black,
                        ),
                      ),
                    ),
                    if (trailingIcon != null)
                      Icon(
                        trailingIcon,
                        color: textColor ?? Theme.of(context).primaryColor,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
