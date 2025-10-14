import 'package:event_planning_app/core/utils/services/toast_services.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppToast {
  static ToastService get _service => getIt<ToastService>();

  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = const Color(0xFFB26C26),
    Color textColor = Colors.white,
    int timeInSecForIosWeb = 2,
    double fontSize = 16.0,
  }) {
    _service.show(
      message: message,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      timeInSecForIosWeb: timeInSecForIosWeb,
      fontSize: fontSize,
    );
  }

  static void success(String message) {
    show(
      message: message,
      backgroundColor: Colors.green,
      gravity: ToastGravity.TOP,
    );
  }

  static void error(String message) {
    show(
      message: message,
      backgroundColor: Colors.red,
      gravity: ToastGravity.TOP,
    );
  }

  static void warning(String message) {
    show(
      message: message,
      backgroundColor: Colors.orange,
      gravity: ToastGravity.TOP,
    );
  }

  static void info(String message) {
    show(
      message: message,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.TOP,
    );
  }

  static void cancel() {
    _service.cancel();
  }
}
