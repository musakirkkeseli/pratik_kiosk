import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utility/dynamic_theme_provider.dart';
import '../../../../../core/widget/custom_image.dart';
import '../../../../../features/utility/const/constant_color.dart';
import '../../../../../features/utility/const/constant_string.dart';
import '../../cubit/patient_login_cubit.dart';
import 'bouncing_balls_page.dart';
import 'language_button_widget2.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Slider'ları yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientLoginCubit>().fetchSliders();
    });
  }

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
    return BlocBuilder<PatientLoginCubit, PatientLoginState>(
      builder: (context, state) {
        final sliders = state.sliders;
        
        // Slider yoksa varsayılan görseli göster
        if (sliders.isEmpty) {
          return Container(
            height: 200,
            width: double.infinity,
            color: ConstColor.black,
            child: CustomImage.image(
              "https://kiosk.prtk.gen.tr/assets/images/sliders/kioskSlider.png",
              CustomImageType.standart,
            ),
          );
        }

        // Backend'den gelen slider'ları göster
        return Container(
          height: 200,
          width: double.infinity,
          child: PageView(
            children: sliders.map((slider) {
              return CustomImage.image(
                slider.path ?? "",
                CustomImageType.standart,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  _mobilAppQR(String qrCodeUrl) {
    if (qrCodeUrl.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 200,
      width: double.infinity,
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
