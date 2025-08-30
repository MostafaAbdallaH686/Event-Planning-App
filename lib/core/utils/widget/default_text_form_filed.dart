
import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class DefaultTextFormFiled extends StatelessWidget {
  const DefaultTextFormFiled({
    super.key,
    this.label,
    required this.hint,
    this.validator,
    this.controller,
    this.focusNode,
    this.passwordSuffixIcon,
    this.obscureText = false,
    this.onTapSuffixIcon,
    this.maxLines = 1,
    this.minLines,
  });
  final int maxLines;
  final int? minLines;
  final String? label;
  final String hint;
  final bool obscureText;
  final VoidCallback? onTapSuffixIcon;
  final Widget? passwordSuffixIcon;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      focusNode: focusNode,
      obscureText: obscureText,
      cursorHeight: 13,
      cursorColor: AppColor.black,
      cursorWidth: 1,
      style: AppTextStyle.extraLight14(AppColor.black),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        fillColor: AppColor.white,
        filled: true,
        labelStyle:
            AppTextStyle.extraLight14(const Color.fromARGB(255, 3, 2, 2)),
        hintStyle: AppTextStyle.extraLight14(AppColor.colorbr80),
        border: outlineInputBorder(),
        disabledBorder: outlineInputBorder(),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorder(),
        errorBorder: outlineInputBorder(),
        focusedErrorBorder: outlineInputBorder(),
        suffixIcon: passwordSuffixIcon != null
            ? GestureDetector(
                onTap: onTapSuffixIcon,
                child: passwordSuffixIcon,
              )
            : null,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder() => OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.colorbr80,
        ),
        borderRadius: BorderRadius.circular(
            AppWidthHeight.persantageOfWidth((10 / 375) * 100)),
      );
}
