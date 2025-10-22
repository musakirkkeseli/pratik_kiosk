import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kiosk/core/utility/logger_service.dart';

import '../../core/utility/user_login_status_service.dart';
import '../widget/inactivity_warning_dialog.dart';
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
  bool _disposed = false;

  void _notifyLater() {
    if (_disposed) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_disposed) return;
      try {
        notifyListeners();
      } catch (_) {}
    });
  }

  void start() {
    _deadline = DateTime.now().add(totalTimeout);
    _startTicker();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _hideWarningIfAny();
    phase = InactivityPhase.idle;
    _notifyLater();
  }

  /// Kullanıcı etkileşimi olduğunda çağır
  void bump({Duration? customTimeout}) {
    MyLog().d(
      'InactivityController.bump called ${customTimeout ?? totalTimeout}',
    );
    if (phase == InactivityPhase.cleaning) return;
    _deadline = DateTime.now().add(customTimeout ?? totalTimeout);
    phase = InactivityPhase.idle;
    _hideWarningIfAny();
    _notifyLater();
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
      _notifyLater();
      await _performCleanup();
      return;
    }

    if (remaining <= warningBefore &&
        !_dialogShown &&
        phase != InactivityPhase.cleaning) {
      phase = InactivityPhase.warning;
      _showWarningDialog(remaining);
      _notifyLater();
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
      builder: (c) => InactivityWarningDialog(
        remaining: remaining,
        onContinue: () {
          MyLog.debug("'onContinue basıldı'");
          Navigator.of(c).pop();
          _dialogShown = false;
          bump();
        },
        onLogout: () async {
          MyLog.debug("'onLogout basıldı'");
          Navigator.of(c).pop();
          _dialogShown = false;
          phase = InactivityPhase.cleaning;
          notifyListeners();
          await _performCleanup();
        },
      ),
    );
  }

  void _hideWarningIfAny() async {
    if (!_dialogShown) {
      return;
    } else {
      await Future.delayed(Duration(milliseconds: 120));
      if (_dialogShown) {
        final ctx = navigatorKey.currentContext;
        if (ctx != null && Navigator.of(ctx).canPop()) {
          Navigator.of(ctx).pop();
        }
        _dialogShown = false;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _disposed = true;
    super.dispose();
  }
}
