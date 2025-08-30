import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class AppSnakBar {
  static void showSnakBar({required String title, required String message}) {
    Get.snackbar(title, message);
  }

  static void showSnakBar2({required String title, required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          title,
          style: AppTextStyle.regular14(AppColor.colorb26),
        ),
        messageText: Text(
          message,
          style: AppTextStyle.regular14(AppColor.colorb26),
        ),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(
          seconds: 2,
        ),
        backgroundColor: AppColor.scaffoldBackground,
      ),
    );
  }
}
