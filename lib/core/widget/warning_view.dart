import 'package:flutter/material.dart';

import '../../features/utility/extension/text_theme_extension.dart';

class WarningScreen extends StatelessWidget {
  final String title;
  final String desc;
  final String buttonText;
  final Function()? onTap;

  const WarningScreen({
    Key? key,
    required this.title,
    required this.desc,
    required this.buttonText,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off,
                // color: ConstColor.error,
                size: 120,
              ),
              const SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .7,
                child: Column(
                  children: [
                    Text(
                      title,
                      style: context.warningTitle,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      desc,
                      style: context.regularText18,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Visibility(
                visible: onTap != null,
                child: InkWell(
                  onTap: onTap,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(buttonText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
