import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppToast {
  static void show({
    required String message,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = AppColor.colorb26,
    Color textColor = Colors.white,
    int timeInSecForIosWeb = 2,
    double fontSize = 16.0,
  }) {
    cancel();
    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: timeInSecForIosWeb,
      fontSize: fontSize,
    );
  }

  static void cancel() => Fluttertoast.cancel();
}
