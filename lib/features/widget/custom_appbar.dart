import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utility/dynamic_theme_provider.dart';
import '../utility/const/constant_color.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicThemeProvider>(context);
    final logoUrl = themeProvider.logoUrl;

    return SizedBox(
      height: 130,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (logoUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: logoUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => SizedBox(
                child: Center(
                  child: CircularProgressIndicator(color: ConstColor.white),
                ),
              ),
              errorWidget: (context, url, error) {
                return SizedBox();
              },
            )
          else
            SizedBox(),
        ],
      ),
    );
  }
}
