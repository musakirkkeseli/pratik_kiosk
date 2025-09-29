import 'dart:async';

import '../../features/utility/navigation_service.dart';
import 'analytics_service.dart';

enum LoginStatus { online, offline }

class LoginStatusService {
  /// Singleton instance
  static LoginStatusService? _instance;

  final StreamController<LoginStatus> _controller =
      StreamController<LoginStatus>.broadcast();

  /// Private constructor
  LoginStatusService._internal() {
    _loadInitialStatus();
  }

  String? _accessToken;
  String? _refreshToken;

  Stream<LoginStatus> get statusStream => _controller.stream;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<void> _loadInitialStatus() async {
    _controller.add(
      _accessToken == null ? LoginStatus.offline : LoginStatus.online,
    );
  }

  /// Singleton erişimi (ilk seferde cubit verilebilir)
  factory LoginStatusService() {
    return _instance ??= LoginStatusService._internal();
  }

  Future<void> login({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _controller.add(LoginStatus.online);
  }

  refreshTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    AnalyticsService().reset();
    _controller.add(LoginStatus.offline);
    NavigationService.ns.gotoMain();
  }
}
