//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordTextField extends StatelessWidget {
  final UserCubit cubit;
  final TextEditingController controller;
  const PasswordTextField(
      {super.key, required this.cubit, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => current is UserObscureToggled,
      builder: (context, state) {
        return CustomTextform(
          obscureText: cubit.obscureText,
          controller: controller,
          validator: (value) => AppValidator().passwordValidator(value),
          prefixicon: AppIcon.password,
          prefixtext: AppString.enterPass,
          suffixicon: IconButton(
            onPressed: cubit.toggleObscure,
            icon: Icon(
              cubit.obscureText ? Icons.visibility_off : Icons.visibility,
            ),
          ),
        );
      },
    );
  }
}
