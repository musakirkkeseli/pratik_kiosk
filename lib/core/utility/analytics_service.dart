import 'dart:typed_data';

import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../features/utility/const/environment.dart';


class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  late Mixpanel _mixpanel;

  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  Future<void> init() async {
    _mixpanel = await Mixpanel.init(
      Environment.mixpanelToken,
      optOutTrackingDefault: false,
      trackAutomaticEvents: true,
    );
  }

  // 📊 Mixpanel: Event takibi
  void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    _mixpanel.track(eventName, properties: properties);
  }

  // 📊 Mixpanel: Kullanıcı tanımlama
  void identifyUser(String userId) {
    _mixpanel.identify(userId);
  }

  // 📊 Mixpanel: Kullanıcı özellikleri
  void setUserProperties(Map<String, dynamic> properties) {
    properties.forEach((key, value) {
      _mixpanel.getPeople().set(key, value);
    });
  }

  // 📊 Mixpanel: Reset
  void reset() {
    _mixpanel.reset();
  }

  // ⚠️ Sentry: Exception loglama
  void logException(dynamic error, StackTrace stackTrace,
      {Map<String, dynamic>? extras, String? tag}) {
    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (tag != null) scope.setTag('tag', tag);
        if (extras != null) {
          extras.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
      },
    );
  }

  // ⚠️ Sentry: Basit mesaj loglama
  void logMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extras,
    String? tag,
  }) {
    Sentry.captureMessage(
      message,
      level: level,
      withScope: (scope) {
        if (tag != null) scope.setTag('tag', tag);
        if (extras != null) {
          extras.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
      },
    );
  }

  // 📎 Sentry: Kullanıcı geri bildirimi + ekran görüntüsü
  Future<void> logUserFeedback({
    required String comment,
    required Uint8List screenshot,
    String? tag,
  }) async {
    await Sentry.captureEvent(
      SentryEvent(
        level: SentryLevel.info,
        message: SentryMessage('User Feedback'),
        extra: {
          'comment': comment,
        },
      ),
      withScope: (scope) {
        if (tag != null) {
          scope.setTag('tag', tag);
        }

        scope.addAttachment(
          SentryAttachment.fromUint8List(
            screenshot,
            'user_feedback_screenshot.png',
            contentType: 'image/png',
          ),
        );
      },
    );
  }
}
