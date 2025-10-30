//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textform.dart';
import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;

  const NameTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextform(
      controller: controller,
      validator: (value) => AppValidator().nameValidator(value),
      prefixicon: AppIcon.username,
      prefixtext: hintText,
      errorText: errorText,
    );
  }
}
