import 'package:event_planning_app/core/utils/widgets/dialogs/info_dialog.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = "OK",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InfoDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      onPressed: onPressed,
      icon: const Icon(Icons.error, color: Colors.red, size: 48),
    );
  }
}
