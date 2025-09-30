import 'dart:async';

import '../../features/utility/navigation_service.dart';
import 'analytics_service.dart';
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

  Stream<UserLoginStatus> get statusStream => _controller.stream;

  String? get accessToken => _accessToken;

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
    _controller.add(UserLoginStatus.online);

    // AnalyticsService().identifyUser(userId.toString());
    // AnalyticsService().setUserProperties({
    //   "Name": name,
    //   "Phone": phone,
    //   "Company City": cityName,
    //   "Login Time": DateTime.now().toIso8601String(),
    // });
    MyLog.debug("UserLoginStatusService login");
  }

  refreshTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
  }

  Future<void> logout() async {
    _accessToken = null;
    AnalyticsService().reset();
    _controller.add(UserLoginStatus.offline);
    NavigationService.ns.gotoMain();
  }
}
