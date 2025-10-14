import 'package:event_planning_app/core/utils/widgets/dialogs/confirm_dialog.dart';
import 'package:event_planning_app/core/utils/widgets/dialogs/error_dialog.dart';
import 'package:event_planning_app/core/utils/widgets/dialogs/info_dialog.dart';
import 'package:event_planning_app/core/utils/widgets/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';

class AppDialog {
  /// Show informational dialog
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = "OK",
    VoidCallback? onPressed,
    bool barrierDismissible = true,
    Widget? icon,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }

  /// Show confirmation dialog - returns true if confirmed, false if cancelled, null if dismissed
  static Future<bool?> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    bool isDanger = false,
    Widget? icon,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDanger: isDanger,
        icon: icon,
      ),
    );
  }

  /// Show error dialog
  static Future<void> showError({
    required BuildContext context,
    required String message,
    String title = "Error",
    String buttonText = "OK",
    VoidCallback? onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }

  /// Show loading dialog
  static void showLoading({
    required BuildContext context,
    String message = "Loading...",
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingDialog(message: message),
    );
  }

  /// Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  /// Show success dialog
  static Future<void> showSuccess({
    required BuildContext context,
    required String message,
    String title = "Success",
    String buttonText = "OK",
    VoidCallback? onPressed,
  }) {
    return showInfo(
      context: context,
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
    );
  }
}
