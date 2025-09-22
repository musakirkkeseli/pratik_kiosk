import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/utility/app_storage.dart';
import 'analytics_service.dart';

import 'logger_service.dart';

enum LoginStatus { online, offline, failed }

class LoginStatusService {
  /// Singleton instance
  static LoginStatusService? _instance;

  final StreamController<LoginStatus> _controller =
      StreamController<LoginStatus>.broadcast();

  /// Private constructor
  LoginStatusService._internal() {
    _loadInitialStatus();
  }

  Stream<LoginStatus> get statusStream => _controller.stream;

  Future<void> _loadInitialStatus() async {
    final token = await AppStorage().getToken();
    _controller.add(token == null ? LoginStatus.offline : LoginStatus.online);
  }

  /// Singleton erişimi (ilk seferde cubit verilebilir)
  factory LoginStatusService() {
    return _instance ??= LoginStatusService._internal();
  }

  LoginStatus getCurrentStatus() {
    return Hive.box("userbox").get("token") == null
        ? LoginStatus.offline
        : LoginStatus.online;
  }

  Future<void> login({
    required String token,
    required int userId,
    required String cityName,
    required String name,
    required String phone,
  }) async {
    await AppStorage().saveToken(token);
    AnalyticsService().identifyUser(userId.toString());
    AnalyticsService().setUserProperties({
      "Name": name,
      "Phone": phone,
      "Company City": cityName,
      "Login Time": DateTime.now().toIso8601String(),
    });
    MyLog.debug("LoginStatusService login");
  }

  Future<void> logout() async {
    await AppStorage().getToken();
    AnalyticsService().reset();
  }
}
