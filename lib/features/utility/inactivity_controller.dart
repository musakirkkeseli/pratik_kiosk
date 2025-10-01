// lib/core/inactivity_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kiosk/core/utility/logger_service.dart';

import '../../core/utility/user_login_status_service.dart';
import 'navigation_service.dart';

enum InactivityPhase { idle, warning, cleaning }

class InactivityController extends ChangeNotifier {
  final Duration totalTimeout;
  final Duration warningBefore;
  InactivityController({
    required this.totalTimeout,
    required this.warningBefore,
  });

  NavigationService ns = NavigationService.ns;
  final GlobalKey<NavigatorState> navigatorKey =
      NavigationService.ns.navigatorKey;
  Timer? _timer;
  DateTime _deadline = DateTime.now();
  bool _dialogShown = false;
  InactivityPhase phase = InactivityPhase.idle;

  void start() {
    _deadline = DateTime.now().add(totalTimeout);
    _startTicker();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _hideWarningIfAny();
    phase = InactivityPhase.idle;
    notifyListeners();
  }

  /// Kullanıcı etkileşimi olduğunda çağır
  void bump() {
    MyLog().d('InactivityController.bump called');
    if (phase == InactivityPhase.cleaning) return;
    _deadline = DateTime.now().add(totalTimeout);
    phase = InactivityPhase.idle;
    _hideWarningIfAny();
    notifyListeners();
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  Future<void> _tick() async {
    final now = DateTime.now();
    final remaining = _deadline.difference(now);

    if (remaining <= Duration.zero && phase != InactivityPhase.cleaning) {
      phase = InactivityPhase.cleaning;
      _hideWarningIfAny();
      notifyListeners();
      await _performCleanup();
      return;
    }

    // Uyarı eşiği
    if (remaining <= warningBefore &&
        !_dialogShown &&
        phase != InactivityPhase.cleaning) {
      phase = InactivityPhase.warning;
      _showWarningDialog(remaining);
      notifyListeners();
    }
  }

  Future<void> _performCleanup() async {
    try {
      await UserLoginStatusService().logout();
    } catch (_) {}
  }

  void _showWarningDialog(Duration remaining) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    _dialogShown = true;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (c) {
        // Her 1 sn’de bir kalan süreyi güncellemek istiyorsan StatefulBuilder kullanılabilir.
        return AlertDialog(
          title: const Text('Oturum Zaman Aşımı'),
          content: _WarningCountdown(remaining: warningBefore),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(c).pop();
                _dialogShown = false;
                bump(); // devam et
              },
              child: const Text('Devam Et'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(c).pop();
                _dialogShown = false;
                phase = InactivityPhase.cleaning;
                notifyListeners();
                await _performCleanup();
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        );
      },
    );
  }

  void _hideWarningIfAny() {
    if (!_dialogShown) return;
    final ctx = navigatorKey.currentContext;
    if (ctx != null && Navigator.of(ctx).canPop()) {
      Navigator.of(ctx).pop();
    }
    _dialogShown = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class _WarningCountdown extends StatefulWidget {
  const _WarningCountdown({required this.remaining});
  final Duration remaining;
  @override
  State<_WarningCountdown> createState() => _WarningCountdownState();
}

class _WarningCountdownState extends State<_WarningCountdown> {
  late Duration _left;
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _left = widget.remaining;
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _left = _left - const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = _left.inSeconds.clamp(0, 9999);
    return Text('İşleminiz otomatik olarak ${s} sn sonra sonlandırılacak.');
  }
}
