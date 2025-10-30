//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textform.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordVisible;
  final VoidCallback onToggleVisibility;
  final String? errorText;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.isPasswordVisible,
    required this.onToggleVisibility,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextform(
      obscureText: !isPasswordVisible,
      controller: controller,
      validator: (value) => AppValidator().passwordValidator(value),
      prefixicon: AppIcon.password,
      prefixtext: AppString.enterPass,
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
