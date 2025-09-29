import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextbutton extends StatelessWidget {
  const CustomTextbutton(
      {super.key,
      required this.text,
      required this.onpressed,
      this.isIconAdded = false});

  final String text;
  final VoidCallback onpressed;
  final bool isIconAdded;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: GestureDetector(
        onTap: () {
          onpressed();
        },
        child: Container(
          width: size.width * 0.6833,
          height: size.height * 0.06625,
          decoration: BoxDecoration(
            color: AppColor.sharedbutton,
            borderRadius: AppRadius.buttonRaduis,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.center,
                text,
                style: AppTextStyle.medium18(AppColor.colorwEE),
              ),
              const SizedBox(width: 5),
              isIconAdded == false
                  ? const SizedBox()
                  : SvgPicture.asset(AppIcon.forwardArrow),
            ],
          ),
        ),
      ),
    );
  }
}
