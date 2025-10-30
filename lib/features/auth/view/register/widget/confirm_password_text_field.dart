//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textform.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;
  final String hintText;
  final String? errorText;

  const ConfirmPasswordTextField({
    super.key,
    required this.controller,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.onToggleVisibility,
    required this.hintText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextform(
      obscureText: !isPasswordVisible,
      controller: controller,
      validator: (value) => AppValidator().confirmPasswordValidator(
        value,
        passwordController.text,
      ),
      prefixicon: AppIcon.password,
      prefixtext: hintText,
      errorText: errorText,
      suffixicon: IconButton(
        onPressed: onToggleVisibility,
        icon: Icon(
          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
      ),
    );
  }
}
