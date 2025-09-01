import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomFirebasebutton extends StatelessWidget {
  const CustomFirebasebutton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onpressed});
  final String icon;
  final String text;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: size.width * 0.9571,
        height: size.height * 0.07,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
            onPressed: onpressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(icon),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: AppTextStyle.bold16(AppColor.colorbA1),
                )
              ],
            )),
      ),
    );
  }
}
