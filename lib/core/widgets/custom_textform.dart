import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextform extends StatelessWidget {
  const CustomTextform({
    super.key,
    required this.prefixicon,
    required this.prefixtext,
    this.suffixicon,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  final String prefixicon;
  final String prefixtext;
  final Widget? suffixicon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.07,
      margin: EdgeInsets.only(
        left: size.width * 0.0278,
        right: size.width * 0.0278,
        top: size.height * 0.025,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.055,
        vertical: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        border: Border.all(color: AppColor.border),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: SvgPicture.asset(prefixicon),
          hintText: prefixtext,
          hintStyle: AppTextStyle.reg14(AppColor.colorbA1),
          suffixIcon: suffixicon ?? const SizedBox(),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
