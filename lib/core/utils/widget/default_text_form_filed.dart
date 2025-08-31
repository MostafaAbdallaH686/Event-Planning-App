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
    this.isPassword = false,
  });
  final int maxLines;
  final bool isPassword;
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
      decoration: InputDecoration(
        hintText: hint,
        fillColor: AppColor.white,
        filled: true,
        hintStyle: AppTextStyle.extraLight14(AppColor.colorbr80),
        border: OutlineInputBorder(),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: onTapSuffixIcon,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColor.colorbr80,
                ),
              )
            : passwordSuffixIcon,
      ),
    );
  }
}
