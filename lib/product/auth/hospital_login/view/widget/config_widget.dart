import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_animations/simple_animations.dart';
import '../../../../../features/utility/const/constant_string.dart';

class ConfigWidget extends StatefulWidget {
  const ConfigWidget({super.key});

  @override
  State<ConfigWidget> createState() => _ConfigWidgetState();
}

class _ConfigWidgetState extends State<ConfigWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xfff44336), Color(0xff2196f3)],
                stops: [0, 1],
              ),
              backgroundBlendMode: BlendMode.srcOver,
            ),
            child: PlasmaRenderer(
              type: PlasmaType.infinity,
              particles: 10,
              color: Color(0x4423c2e4),
              blur: 0.4,
              size: 1,
              speed: 3.75,
              offset: 0,
              blendMode: BlendMode.plus,
              particleType: ParticleType.atlas,
              variation1: 0,
              variation2: 0,
              variation3: 0,
              rotation: 0,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Lottie.asset(
                ConstantString.settingsGif,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                repeat: true,
              ),
              SizedBox(height: 20,),
              Text(
                'Ayarlar Uygulanıyor...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Lottie.asset(
              //   ConstantString.configLoading,
              //   width: 120,
              //   height: 120,
              //   fit: BoxFit.cover,
              //   repeat: true,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
