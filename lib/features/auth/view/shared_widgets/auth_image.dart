import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:flutter/material.dart';

class AuthImage extends StatelessWidget {
  const AuthImage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.038),
        Container(
          width: double.infinity,
          height: size.height * 0.30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImage.auth),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Text(
            textAlign: TextAlign.center,
            title,
            style: AppTextStyle.bold24(AppColor.black),
          ),
        ),
      ],
    );
  }
}
