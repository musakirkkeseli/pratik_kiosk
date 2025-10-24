import 'package:flutter/material.dart';
import 'package:kiosk/core/utility/logger_service.dart';
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

  /// Optional label for the secondary action button. Defaults to 'Çıkış Yap'.
  final String? secondaryLabel;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.timer_outlined),
          const SizedBox(width: 8),
          Text(title ?? 'Oturum Zaman Aşımı', style: context.sectionTitle),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          Text(
            message ?? 'İşleminize devam etmezseniz oturumunuz kapanacaktır.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          CircularCountdown(
            total: remaining,
            size: 120,
            strokeWidth: 8,
            color: color,
            backgroundColor: Colors.grey.shade300,
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
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            child: Text(secondaryLabel ?? 'Çıkış Yap', style: context.buttonText),
          ),

        ElevatedButton(
          onPressed: () {
            MyLog.debug("'onContinue tetiklendi'");
            onContinue!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: onPrimary,
          ),
          child: Text('Devam Et', style: context.buttonText),
        ),
      ],
    );
  }
}
