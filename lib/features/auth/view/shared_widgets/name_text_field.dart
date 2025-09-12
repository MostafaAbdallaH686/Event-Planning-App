//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  final UserCubit cubit;
  final String hintText;
  final TextEditingController controller;

  const NameTextField({
    super.key,
    required this.cubit,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextform(
      controller: controller,
      validator: (value) => AppValidator().nameValidator(value),
      prefixicon: AppIcon.username,
      prefixtext: hintText,
    );
  }
}
