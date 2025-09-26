import 'package:flutter/material.dart';

class SnackbarService {
  // Singleton instance
  static final SnackbarService _instance = SnackbarService._internal();
  factory SnackbarService() => _instance;
  SnackbarService._internal();

  // Private scaffold messenger key
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Getter to access the key
  GlobalKey<ScaffoldMessengerState> get key => _scaffoldMessengerKey;

  // Public method to show SnackBar
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    final messenger = _scaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
        ),
      );
    }
  }
}
