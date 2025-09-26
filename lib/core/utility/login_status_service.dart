import 'dart:async';

import '../../features/utility/app_storage.dart';
import 'analytics_service.dart';

import 'logger_service.dart';

enum LoginStatus { online, offline, failed }

class LoginStatusService {
  /// Singleton instance
  static LoginStatusService? _instance;

  final StreamController<LoginStatus> controller =
      StreamController<LoginStatus>.broadcast();

  /// Private constructor
  LoginStatusService._internal() {
    _loadInitialStatus();
  }

  Stream<LoginStatus> get statusStream => controller.stream;

  Future<void> _loadInitialStatus() async {
    final token = await AppStorage().getToken();
    controller.add(token == null ? LoginStatus.offline : LoginStatus.online);
  }

  /// Singleton erişimi (ilk seferde cubit verilebilir)
  factory LoginStatusService() {
    return _instance ??= LoginStatusService._internal();
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
