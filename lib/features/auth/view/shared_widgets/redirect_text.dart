//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedirectLink extends StatelessWidget {
  final String questionText;
  final String actionText;
  final String route;

  const RedirectLink({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          questionText,
          style: AppTextStyle.bold14(AppColor.colorbA1),
        ),
        TextButton(
          onPressed: () => context.push(route),
          child: Text(
            actionText,
            style: AppTextStyle.bold14(AppColor.colorbr80).copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
