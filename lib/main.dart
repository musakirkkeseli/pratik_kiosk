import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/utility/login_status_service.dart';
import 'core/utility/network_status_service.dart';
import 'core/utility/user_login_status_service.dart';
import 'core/widget/login_aware_widget.dart';
import 'features/utility/app_initialize.dart';
import 'features/utility/const/constant_string.dart';
import 'features/utility/navigation_service.dart';
import 'features/utility/route_generator.dart';

Future<void> main() async {
  await AppInitialize.initialize();
  var connectivityResult = await (Connectivity().checkConnectivity());

  runApp(
    EasyLocalization(
      supportedLocales: ConstantString.SUPPORTED_LOCALE,
      path: ConstantString.LANG_PATH,
      startLocale: ConstantString.TR_LOCALE,
      child: MultiProvider(
        providers: [
          //kullanıcının uygulamayı kullanırken cihazın internete bağlılık durumunu dinleyen NetworkStatusService sınıfının durumunu tüm uygulamaya yayınlar
          StreamProvider<NetworkStatus>(
            create: (context) =>
                NetworkStatusService().networkStatusController.stream,
            initialData:
                connectivityResult.contains(ConnectivityResult.mobile) ||
                    connectivityResult.contains(ConnectivityResult.ethernet) ||
                    connectivityResult.contains(ConnectivityResult.vpn) ||
                    connectivityResult.contains(ConnectivityResult.wifi)
                ? NetworkStatus.online
                : NetworkStatus.offline,
          ),
          StreamProvider<LoginStatus>(
            create: (_) => LoginStatusService().statusStream,
            initialData: LoginStatus.offline,
          ),
          StreamProvider<UserLoginStatus>(
            create: (_) => UserLoginStatusService().statusStream,
            initialData: UserLoginStatus.offline,
          ),
        ],
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      routes: {'/': (context) => LoginAwareWidget()},
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoutes,
      navigatorKey: NavigationService.ns.navigatorKey,
      navigatorObservers: [NavigationService.ns],
    );
  }
}
