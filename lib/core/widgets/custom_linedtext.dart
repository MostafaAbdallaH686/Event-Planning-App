import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class LinedText extends StatelessWidget {
  final String text;

  const LinedText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 1,
            color: AppColor.border,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text,
            style: AppTextStyle.reg11(AppColor.border),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 1,
            color: AppColor.border,
          ),
        ),
      ],
    );
  }
}
