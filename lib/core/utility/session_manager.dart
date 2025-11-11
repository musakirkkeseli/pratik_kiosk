import 'dart:async';

import 'package:uuid/uuid.dart';

/// Reasons that terminate a kiosk session.
enum SessionEndReason {
  manual,
  timeout,
  completed,
  error,
  fallback,
}

extension SessionEndReasonLabel on SessionEndReason {
  String get label {
    switch (this) {
      case SessionEndReason.manual:
        return 'manual';
      case SessionEndReason.timeout:
        return 'timeout';
      case SessionEndReason.completed:
        return 'completed';
      case SessionEndReason.error:
        return 'error';
      case SessionEndReason.fallback:
        return 'fallback';
    }
  }
}

/// Snapshot of a kiosk session lifecycle.
class SessionSnapshot {
  SessionSnapshot({
    required this.sessionId,
    required this.startedAt,
    DateTime? endedAt,
    Duration? duration,
    this.endReason,
  })  : endedAt = endedAt ?? DateTime.now(),
        duration = duration ?? DateTime.now().difference(startedAt);

  final String sessionId;
  final DateTime startedAt;
  final DateTime endedAt;
  final Duration duration;
  final SessionEndReason? endReason;

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'duration': _formatDuration(duration),
        if (endReason != null) 'end_reason': endReason!.label,
      };

  static String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds}sn';
    }
    final minutes = duration.inSeconds / 60;
    if (minutes == minutes.floorToDouble()) {
      return '${minutes.toInt()}dk';
    }
    return '${minutes.toStringAsFixed(1)}dk';
  }
}

/// Responsible for lifecycle of anonymity-friendly kiosk sessions.
class SessionManager {
  SessionManager._internal();

  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  final _uuid = const Uuid();
  final StreamController<SessionSnapshot> _sessionEvents =
      StreamController<SessionSnapshot>.broadcast();

  String? _currentSessionId;
  DateTime? _startedAt;

  Stream<SessionSnapshot> get sessionEvents => _sessionEvents.stream;

  String? get currentSessionId => _currentSessionId;
  DateTime? get startedAt => _startedAt;
  bool get hasActiveSession => _currentSessionId != null;

  /// Ends the running session if any and starts a fresh one.
  SessionSnapshot startNewSession() {
    if (hasActiveSession) {
      endSession(reason: SessionEndReason.fallback);
    }
    _currentSessionId = _uuid.v4();
    _startedAt = DateTime.now();
    final snapshot = SessionSnapshot(
      sessionId: _currentSessionId!,
      startedAt: _startedAt!,
      duration: Duration.zero,
    );
    _sessionEvents.add(snapshot);
    return snapshot;
  }

  /// Ends the active session and notifies listeners.
  SessionSnapshot? endSession({required SessionEndReason reason}) {
    if (!hasActiveSession || _startedAt == null) {
      return null;
    }
    final snapshot = SessionSnapshot(
      sessionId: _currentSessionId!,
      startedAt: _startedAt!,
      endReason: reason,
    );
    _currentSessionId = null;
    _startedAt = null;
    _sessionEvents.add(snapshot);
    return snapshot;
  }
}
