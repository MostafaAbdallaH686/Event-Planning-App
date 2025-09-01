import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_radius.dart';
import 'package:flutter/material.dart';

class CustomTextbutton extends StatelessWidget {
  const CustomTextbutton(
      {super.key, required this.text, required this.onpressed});

  final String text;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.6833,
        height: size.height * 0.06625,
        decoration: BoxDecoration(
          color: AppColor.colorbr80,
          borderRadius: AppRadius.buttonRaduis,
        ),
        child: TextButton(
            onPressed: () {
              onpressed();
            },
            child: Text(
              text,
              style: AppTextStyle.reg18(AppColor.colorwEE),
            )),
      ),
    );
  }
}
