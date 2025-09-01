import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:flutter/material.dart';

class CustomOnboarding extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onPressed;

  const CustomOnboarding({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            width: size.width * 1,
            height: size.height * 0.5,
            fit: BoxFit.cover,
          ),
          SizedBox(height: size.height * 0.05),
          Text(
            textAlign: TextAlign.center,
            title,
            style: AppTextStyle.bold24(AppColor.colorbA1),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            textAlign: TextAlign.center,
            AppString.onboardingsubtitle1,
            style: AppTextStyle.extraLight14(AppColor.black),
          ),
          SizedBox(height: size.height * 0.01),
          CustomTextbutton(
            text: AppString.onboardingbtn,
            onpressed: onPressed,
          ),
        ],
      ),
    );
  }
}
