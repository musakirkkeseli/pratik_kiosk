import 'package:flutter/material.dart';

import '../../features/utility/const/constant_string.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image(image: AssetImage(ConstantString.loadingGif), width: 200),
      );
  }
}
