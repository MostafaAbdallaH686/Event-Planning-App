import 'package:event_planning_app/core/utils/utils/app_radius.dart';
import 'package:flutter/material.dart';

class AppDialog {
  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = "OK",
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "OK",
    String cancelText = "Cancel",
    void Function()? onConfirm,
    void Function()? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.dialogRadius,
          ),
          actions: [
            TextButton(
              onPressed: onCancel ?? () => Navigator.of(context).pop(),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: onConfirm ?? () => Navigator.of(context).pop(),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
