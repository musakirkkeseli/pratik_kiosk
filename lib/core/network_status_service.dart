import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class NetworkStatusService {
  StreamController<NetworkStatus> networkStatusController =
      StreamController<NetworkStatus>();

  NetworkStatusService() {
    Connectivity().onConnectivityChanged.listen((status) {
      networkStatusController.add(_getNetworkStatus(status));
    });
  }

  NetworkStatus _getNetworkStatus(List<ConnectivityResult> status) {
    return status.contains(ConnectivityResult.mobile) ||
            status.contains(ConnectivityResult.ethernet) ||
            status.contains(ConnectivityResult.vpn) ||
            status.contains(ConnectivityResult.wifi)
        ? NetworkStatus.online
        : NetworkStatus.offline;
  }
}
