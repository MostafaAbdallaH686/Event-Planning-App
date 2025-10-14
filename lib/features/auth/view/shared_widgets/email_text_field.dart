//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textform.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final UserCubit cubit;
  final String hintText;
  final TextEditingController controller;

  const EmailTextField({
    super.key,
    required this.cubit,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextform(
      controller: controller,
      validator: (value) => AppValidator().emailValidator(value),
      prefixicon: AppIcon.mail,
      prefixtext: hintText,
    );
  }
}
