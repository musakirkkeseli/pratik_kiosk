import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      // case "forceUpdate":
      //   return MaterialPageRoute(builder: (context) => ForceUpdate());
      // case "chatView":
      //   final args = settings.arguments as Map;
      //   return MaterialPageRoute(
      //     builder: (_) => ChatBlocView(
      //       screenName: settings.name ?? "Unknown",
      //       chatRoomModel: args["chatRoomModel"],
      //       companyId: args["companyId"],
      //     ),
      //     settings: RouteSettings(name: settings.name),
      //   );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(),
          settings: RouteSettings(name: settings.name),
        );
    }
  }
}
