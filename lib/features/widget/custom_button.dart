import 'package:flutter/material.dart';

import '../utility/extension/text_theme_extension.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final double? iconSpacing;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.iconSize,
    this.iconSpacing,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor ?? Colors.white,
          elevation: elevation ?? 2,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: iconSize ?? 24,
                    color: textColor ?? Colors.white,
                  ),
                  SizedBox(width: iconSpacing ?? 8),
                  Text(
                    label,
                    style: context.buttonText.copyWith(
                      fontSize: fontSize ?? 16,
                      color: textColor ?? Colors.white,
                      fontWeight: fontWeight,
                    ),
                  ),
                ],
              )
            : Text(
                label,
                style: context.buttonText.copyWith(
                  fontSize: fontSize ?? 16,
                  color: textColor ?? Colors.white,
                  fontWeight: fontWeight,
                ),
              ),
      ),
    );
  }
}
