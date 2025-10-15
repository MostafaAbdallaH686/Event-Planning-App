import 'package:event_planning_app/core/utils/services/toast_services.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppToast {
  static ToastService? get _serviceOrNull =>
      getIt.isRegistered<ToastService>() ? getIt<ToastService>() : null;

  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = const Color(0xFFB26C26),
    Color textColor = Colors.white,
    int timeInSecForIosWeb = 2,
    double fontSize = 16.0,
  }) {
    final s = _serviceOrNull;
    if (s == null) {
      debugPrint('AppToast: ToastService not registered. Message: $message');
      return;
    }
    try {
      s.show(
        message: message,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: textColor,
        timeInSecForIosWeb: timeInSecForIosWeb,
        fontSize: fontSize,
      );
    } catch (e, st) {
      debugPrint('AppToast show failed: $e\n$st');
    }
  }

  static void success(String message) =>
      show(message: message, backgroundColor: Colors.green);

  static void error(String message) =>
      show(message: message, backgroundColor: Colors.red);

  static void warning(String message) =>
      show(message: message, backgroundColor: Colors.orange);

  static void info(String message) =>
      show(message: message, backgroundColor: Colors.blue);

  static void cancel() {
    final s = _serviceOrNull;
    if (s == null) return;
    try {
      s.cancel();
    } catch (e, st) {
      debugPrint('AppToast cancel failed: $e\n$st');
    }
  }
}
