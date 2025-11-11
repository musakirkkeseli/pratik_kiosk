import 'package:flutter/material.dart';
import '../../core/utility/analytics_service.dart';
import '../../core/utility/logger_service.dart';

class NavigationService extends NavigatorObserver {
  NavigationService._();

  static final NavigationService ns = NavigationService._();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String? currentRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
  final routeName = route.settings.name ?? route.runtimeType.toString();
  currentRoute = routeName;
  MyLog("Navigated to:").d(currentRoute);

    final args = route.settings.arguments;
    Map<String, dynamic>? analyticsArgs;
    if (args is Map) {
      final extracted = <String, dynamic>{};
      args.forEach((key, value) {
        if (key is String &&
            (value is num || value is String || value is bool)) {
          extracted['arg_$key'] = value;
        }
      });
      if (extracted.isNotEmpty) {
        analyticsArgs = extracted;
      }
    }

    AnalyticsService().trackScreenView(
      routeName,
      extra: analyticsArgs,
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentRoute = previousRoute?.settings.name;
    MyLog("Returned to:").d(currentRoute);
  }

  /// 🔁 Normal yönlendirme
  dynamic routeTo(String route, {dynamic arguments}) {
    MyLog("routeTo:").d(currentRoute);
    return navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  Future<dynamic> futureRouteTo(String route, {dynamic arguments}) async {
    MyLog("futureRouteTo:").d(currentRoute);
    return navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  /// Ana sayfaya yönlendir
  Future<dynamic> gotoMain() async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/',
      (val) => false,
    );
  }

  /// Zorunlu güncelleme ekranına yönlendir
  Future<dynamic> gotoForceUpdate() async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      'forceUpdate',
      (val) => false,
    );
  }

  /// Geri git
  dynamic goBack() {
    return navigatorKey.currentState?.pop();
  }

  dynamic goBackData(dynamic result) {
    return navigatorKey.currentState?.pop(result);
  }

  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
}
