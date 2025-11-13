import 'package:flutter/material.dart';
import 'package:kiosk/core/utility/logger_service.dart';
import 'package:kiosk/features/utility/const/constant_color.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';
import '../utility/const/constant_string.dart';
import 'circular_countdown.dart';
import '../utility/extension/text_theme_extension.dart';

class InactivityWarningDialog extends StatelessWidget {
  const InactivityWarningDialog({
    super.key,
    required this.remaining,
    required this.onContinue,
    this.onLogout,
    this.secondaryLabel,
    this.title,
    this.message,
  });

  final Duration remaining;
  final void Function()? onContinue;
  final void Function()? onLogout;

  final String? secondaryLabel;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.timer_outlined, color: context.primaryColor),
          const SizedBox(width: 8),
          Text(
            title ?? ConstantString().sessionTimeout,
            style: context.sectionTitle,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            message ?? ConstantString().sessionWillCloseIfInactive,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          CircularCountdown(
            total: remaining,
            size: 120,
            strokeWidth: 8,
            color: color,
            backgroundColor: ConstColor.grey300,
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      actions: [
        if (onLogout != null)
          OutlinedButton(
            onPressed: () {
              MyLog.debug("'onLogout tetiklendi'");
              onLogout!();
            },
            style: OutlinedButton.styleFrom(foregroundColor: ConstColor.red),
            child: Text(
              secondaryLabel ?? ConstantString().logout,
              style: context.buttonText,
            ),
          ),

        OutlinedButton(
          onPressed: () {
            MyLog.debug("'onContinue tetiklendi'");
            onContinue!();
          },
          child: Text(ConstantString().continueLabel),
        ),
      ],
    );
  }
}
