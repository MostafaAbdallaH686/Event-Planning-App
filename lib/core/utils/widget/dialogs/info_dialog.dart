import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:event_planning_app/core/utils/utils/app_distance.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final Widget? icon;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = "OK",
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppWidthHeight.percentageOfWidth(context, AppDistance.d12),
        ),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 12),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onPressed?.call();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
