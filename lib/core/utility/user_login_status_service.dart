import 'dart:async';

import 'package:provider/provider.dart';

import '../../features/utility/inactivity_controller.dart';
import '../../features/utility/navigation_service.dart';
import 'analytics_service.dart';
import 'session_manager.dart';
import 'logger_service.dart';

enum UserLoginStatus { online, offline }

class UserLoginStatusService {
  /// Singleton instance
  static UserLoginStatusService? _instance;

  final StreamController<UserLoginStatus> _controller =
      StreamController<UserLoginStatus>.broadcast();

  /// Private constructor
  UserLoginStatusService._internal() {
    _loadInitialStatus();
  }

  String? _accessToken;
  String? _userName;

  Stream<UserLoginStatus> get statusStream => _controller.stream;

  String? get accessToken => _accessToken;
  String? get userName => _userName;

  Future<void> _loadInitialStatus() async {
    _controller.add(
      _accessToken == null ? UserLoginStatus.offline : UserLoginStatus.online,
    );
  }

  /// Singleton erişimi (ilk seferde cubit verilebilir)
  factory UserLoginStatusService() {
    return _instance ??= UserLoginStatusService._internal();
  }

  Future<void> login({
    required String accessToken,
    required int userId,
    required String cityName,
    required String name,
    required String phone,
  }) async {
    _accessToken = accessToken;
    _userName = name;
    _controller.add(UserLoginStatus.online);
    _inactivityStartSafe();
  await AnalyticsService().identifyUser(userId.toString());
  await AnalyticsService().startSession(origin: 'patient_login');
    await AnalyticsService().setUserProperties({
      "Name": "Lokman Hekim 3.kat",
      // "Phone": phone,
      // "Company City": cityName,
      // "Login Time": DateTime.now().toIso8601String(),
    });
    MyLog.debug("UserLoginStatusService login");
  }

  refreshTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
  }

  Future<void> logout({SessionEndReason reason = SessionEndReason.manual}) async {
    _accessToken = null;
    _userName = null;
    await AnalyticsService().endSession(reason);
    _controller.add(UserLoginStatus.offline);
    _inactivityStopSafe();
    NavigationService.ns.gotoMain();
  }

  void _inactivityStartSafe() {
    final ctx = NavigationService.ns.navigatorKey.currentContext;
    if (ctx == null) return;
    try {
      ctx.read<InactivityController>().start();
      MyLog.debug("InactivityController.start() called");
    } catch (e) {
      MyLog.debug("Inactivity start failed: $e");
    }
  }

  void _inactivityStopSafe() {
    final ctx = NavigationService.ns.navigatorKey.currentContext;
    if (ctx == null) return;
    try {
      ctx.read<InactivityController>().stop();
      MyLog.debug("InactivityController.stop() called");
    } catch (e) {
      MyLog.debug("Inactivity stop failed: $e");
    }
  }
}
