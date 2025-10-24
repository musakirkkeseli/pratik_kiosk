import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../core/utility/language_manager.dart';
import '../../../core/utility/user_login_status_service.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_home_item.dart';
import '../../../features/utility/extension/text_theme_extension.dart';
import '../../../features/utility/extension/color_extension.dart';
import '../../../features/widget/custom_appbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  "Hoşgeldiniz Sayın Musa Kırkkeseli",
                  style: context.pageTitle,
                ),
              ),
              Spacer(),
              // IconButton(
              //   onPressed: () {
              //     changeLanguageSheet(context);
              //   },
              //   icon: Icon(Icons.language),
              // ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: context.primaryColor,
                      elevation: 0,
                      side: BorderSide(
                        color: context.primaryColor,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                    UserLoginStatusService().logout();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Iconify(
                        MaterialSymbols.exit_to_app,
                        color: context.primaryColor,
                      ),
                      Text(
                        ConstantString().logout,
                        style: context.buttonText.copyWith(
                          color: context.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: EnumHomeItem.values.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                      ),
                      title: Text(
                        EnumHomeItem.values[index].label,
                        style: context.sectionTitle,
                      ),
                      leading: EnumHomeItem.values[index].icon(context),
                    ),
                    EnumHomeItem.values[index].widget(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
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
              children: LanguageManager.instance.appSupportLanguageList
                  .map(
                    (e) => Column(
                      children: [
                        ListTile(
                          leading: SizedBox(height: 30, width: 30),
                          title: Text(e.language),
                          onTap: () async {
                            await context.setLocale(e.locale);
                            LanguageManager.instance.setLocale(e.locale);
                            // HttpService().updateLanguageHeader(e.locale.languageCode);
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
