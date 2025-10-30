import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/utility/const/constant_string.dart';
import '../utility/network_status_service.dart';
import 'warning_view.dart';

class NetworkAwareWidget extends StatefulWidget {
  final Widget? onlineChild;

  const NetworkAwareWidget({super.key, required this.onlineChild});

  @override
  State<NetworkAwareWidget> createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkStatus>(
      builder: (context, data, child) {
        return data == NetworkStatus.online
            ? widget.onlineChild ?? Container()
            : WarningScreen(
                title: ConstantString().internetConnectionError,
                desc: ConstantString().checkInternetConnection,
                buttonText: "",
                onTap: null,
              );
      },
    );
  }
}
