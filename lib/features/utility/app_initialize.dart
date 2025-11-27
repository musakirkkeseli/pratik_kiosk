import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pratik_pos_integration/pratik_pos_integration.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../core/utility/analytics_service.dart';
import 'const/environment.dart';

final class AppInitialize {
  AppInitialize._();

  static Future<void> initialize() async {
    SentryWidgetsFlutterBinding.ensureInitialized();

    //uygulamada yaşanacak beklenmedik büyük hatalarda ekrana AppErrorWidget widgeti gösterilir
    // ErrorWidget.builder = (FlutterErrorDetails details) {
    //   return CustomErrorWidget();
    // };

    final _ = PosService.instance;

    await dotenv.load(fileName: Environment.fileName);

    await AnalyticsService().init();
  }
}
