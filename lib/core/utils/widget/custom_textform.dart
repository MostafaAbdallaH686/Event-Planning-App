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
    return Padding(
      padding: EdgeInsets.only(
          left: size.width * 0.033,
          top: size.height * 0.01875,
          right: size.width * 0.033),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: SvgPicture.asset(prefixicon, width: 20, height: 20),
          ),
          hintText: prefixtext,
          hintStyle: AppTextStyle.reg14(AppColor.colorbA1),
          suffixIcon: suffixicon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
