import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

abstract class AppSnackBar {
  /// Simple title+message snack bar
  static void showSnackBar(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snack = SnackBar(
      duration: duration,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.bold16(AppColor.colorb26)),
          const SizedBox(height: 4),
          Text(message, style: AppTextStyle.bold20(AppColor.colorb26)),
        ],
      ),
      backgroundColor: AppColor.scaffoldBackground,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  /// Custom‐styled bottom snack bar
  static void showCustomSnackBar(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snack = SnackBar(
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      backgroundColor: AppColor.scaffoldBackground,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppTextStyle.extraLight14(AppColor.colorb26)),
          const SizedBox(height: 4),
          Text(message, style: AppTextStyle.extraLight14(AppColor.colorbA1)),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
