import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    return ".env";
  }

  static String get backendUrl {
    return dotenv.env["BACKEND_URL"] ?? "";
  }

  static String get mixpanelToken {
    return dotenv.env["MIXPANEL_TOKEN"] ?? "";
  }

  static String get sentryDsn {
    return dotenv.env["SENTRY_DSN"] ?? "";
  }
}
