import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utility/dynamic_theme_provider.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DynamicThemeProvider>(context);
    final logoUrl = themeProvider.logoUrl;

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (logoUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: logoUrl,
              width: 200,
              height: 150,
              fit: BoxFit.contain,
              placeholder: (context, url) => SizedBox(
                width: 200,
                height: 150,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
              errorWidget: (context, url, error) {
                return Icon(Icons.business, size: 80, color: Colors.white);
              },
            )
          else
            Icon(Icons.business, size: 80, color: Colors.white),
        ],
      ),
    );
  }
}
