import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCircleProgressInicator extends StatelessWidget {
  const CustomCircleProgressInicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: AppColor.blue);
  }
}
