import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomFirebasebutton extends StatelessWidget {
  const CustomFirebasebutton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onpressed,
      required this.color});
  final String icon;
  final String text;
  final VoidCallback? onpressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: size.width * 0.9571,
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
            onTap: onpressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  icon,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Text(
                  textAlign: TextAlign.center,
                  text,
                  style: AppTextStyle.bold16(AppColor.colorbA1),
                )
              ],
            )),
      ),
    );
  }
}
