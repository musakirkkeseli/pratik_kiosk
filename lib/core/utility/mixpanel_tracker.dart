import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import 'offline_event_queue.dart';

class MixpanelTracker {
  MixpanelTracker._internal();

  static final MixpanelTracker _instance = MixpanelTracker._internal();

  factory MixpanelTracker() => _instance;

  Mixpanel? _mixpanel;
  bool _isInitialized = false;
  final OfflineEventQueue _queue = OfflineEventQueue();
  final Map<String, dynamic> _staticSuperProps = {};
  String? _activeSessionId;
  String? _pendingDistinctId;
  final Map<String, dynamic> _pendingPeopleProps = {};
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isFlushing = false;

  bool get _hasClient => _mixpanel != null && _isInitialized;

  Future<void> init({required String token}) async {
    if (_isInitialized) return;
    _mixpanel = await Mixpanel.init(
      token,
      optOutTrackingDefault: false,
      trackAutomaticEvents: false,
    );
    _isInitialized = true;
    if (_staticSuperProps.isNotEmpty) {
      _mixpanel!.registerSuperProperties(_staticSuperProps);
    }
    if (_pendingDistinctId != null) {
      _mixpanel!.identify(_pendingDistinctId!);
      _pendingDistinctId = null;
    }
    if (_pendingPeopleProps.isNotEmpty) {
      _applyPeopleProps(_pendingPeopleProps);
      _pendingPeopleProps.clear();
    }
    await _flushQueue();
    _connectivitySub ??=
        Connectivity().onConnectivityChanged.listen((event) async {
      final hasConnection = event.any(
        (result) => result != ConnectivityResult.none,
      );
      if (hasConnection) {
        await _flushQueue();
      }
    });
  }

  Future<void> dispose() async {
    await _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  void setStaticSuperProperties(Map<String, dynamic> props) {
    props.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      _staticSuperProps[key] = value;
    });
    if (_hasClient) {
      _mixpanel!.registerSuperProperties(_staticSuperProps);
    }
  }

  void attachSession(String sessionId) {
    _activeSessionId = sessionId;
    if (_hasClient) {
      _mixpanel!.registerSuperProperties({'session_id': sessionId});
    }
  }

  void detachSession() {
    _activeSessionId = null;
    if (_hasClient) {
      _mixpanel!.unregisterSuperProperty('session_id');
    }
  }

  void identify(String distinctId) {
    if (_hasClient) {
      _mixpanel!.identify(distinctId);
      _pendingDistinctId = null;
      if (_pendingPeopleProps.isNotEmpty) {
        _applyPeopleProps(_pendingPeopleProps);
        _pendingPeopleProps.clear();
      }
      return;
    }
    _pendingDistinctId = distinctId;
  }

  void setPeopleProperties(Map<String, dynamic> props) {
    if (props.isEmpty) return;
    final cleaned = <String, dynamic>{};
    props.forEach((key, value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      cleaned[key] = value;
    });
    if (cleaned.isEmpty) return;
    if (_hasClient) {
      _applyPeopleProps(cleaned);
      return;
    }
    _pendingPeopleProps.addAll(cleaned);
  }

  void _applyPeopleProps(Map<String, dynamic> props) {
    if (!_hasClient) return;
    final people = _mixpanel!.getPeople();
    props.forEach((key, value) {
      people.set(key, value);
    });
  }

  Future<void> track(
    String eventName, {
    Map<String, dynamic>? properties,
  }) async {
    final payload = <String, dynamic>{
      ..._staticSuperProps,
      if (_activeSessionId != null) 'session_id': _activeSessionId,
      ...?properties,
    }..removeWhere((key, value) {
        if (value == null) return true;
        if (value is String && value.trim().isEmpty) return true;
        return false;
      });

    final queuedEvent = QueuedEvent(
      eventName: eventName,
      properties: payload,
      createdAt: DateTime.now(),
    );

    if (!_hasClient || !(await _isOnline())) {
      await _queue.enqueue(queuedEvent);
      return;
    }

    try {
      _mixpanel!.track(eventName, properties: payload);
    } catch (_) {
      await _queue.enqueue(queuedEvent);
    }
  }

  Future<bool> _isOnline() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.any((result) => result != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  Future<void> _flushQueue() async {
    if (!_hasClient || _isFlushing) return;
    if (!await _isOnline()) return;
    _isFlushing = true;
    try {
      final pending = await _queue.drain();
      if (pending.isEmpty) {
        return;
      }
      final failed = <QueuedEvent>[];
      for (final event in pending) {
        try {
          _mixpanel!.track(event.eventName, properties: event.properties);
        } catch (_) {
          failed.add(event);
        }
      }
      if (failed.isNotEmpty) {
        await _queue.replace(failed);
      }
    } finally {
      _isFlushing = false;
    }
  }
}
