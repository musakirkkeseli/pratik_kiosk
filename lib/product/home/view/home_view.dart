import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';

import '../../../core/utility/user_login_status_service.dart';
import '../../../features/utility/enum/enum_language.dart';
import '../../appointments/view/appointments_view.dart';
import 'widget/section_button_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(ConstantString().homePageTitle),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              UserLoginStatusService().logout();
            },
            child: Text(ConstantString().logout),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            changeLanguageSheet(context);
          },
          icon: Icon(Icons.language),
        ),
      ),
      body: Column(children: [AppointmentsView(), SectionButtonWidget()]),
    );
  }

  changeLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.4,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: LanguageType.values
                    .map(
                      (e) => Column(
                        children: [
                          ListTile(
                            leading: SizedBox(height: 30, width: 30),
                            title: Text(e.countryCodeValue),
                            onTap: () async {
                              await context.setLocale(e.localValue);
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  settings: const RouteSettings(
                                    name: '/tabbar',
                                  ), // Rota adı
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const HomeView(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                          ),
                          const Divider(),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
