import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utility/dynamic_theme_provider.dart';
import '../../../../../core/widget/custom_image.dart';
import '../../../../../features/utility/const/constant_color.dart';
import '../../../../../features/utility/const/constant_string.dart';
import 'bouncing_balls_page.dart';
import 'language_button_widget2.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicThemeProvider>(context);
    final qrCodeUrl = themeProvider.qrCodeUrl;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top),
          _slider(context),
          Expanded(child: BouncingBallsPage(color: context.primaryColor)),
          Padding(
            padding: EdgeInsetsGeometry.only(bottom: 50),
            child: LanguageButtonWidget2(cubitContext: context),
          ),
          _mobilAppQR(qrCodeUrl),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }

  _slider(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: ConstColor.black,
      child: PageView(
        children: [
          CustomImage.image(
            "https://kiosk.prtk.gen.tr/assets/images/sliders/kioskSlider.png",
            CustomImageType.standart,
          ),
          CustomImage.image(
            "https://www.lokmanhekim.com.tr/assets/uploads/catalog/slider/654_Slider-1_1920x1280px-1.webp",
            CustomImageType.standart,
          ),
        ],
      ),
    );
  }

  _mobilAppQR(String qrCodeUrl) {
    if (qrCodeUrl.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      alignment: Alignment.center,
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ConstColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ConstColor.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: CachedNetworkImage(
              imageUrl: qrCodeUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            ),
          ),
          Image.asset(ConstantString.appstoreLight, width: 150, height: 120),
          Image.asset(ConstantString.googlePlayLight, width: 150, height: 120),
        ],
      ),
    );
  }
}
