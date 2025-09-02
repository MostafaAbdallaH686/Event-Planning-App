//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmPasswordTextField extends StatelessWidget {
  final UserCubit cubit;
  final String hintText;

  const ConfirmPasswordTextField({
    super.key,
    required this.cubit,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => current is UserConfirmObscureToggled,
      builder: (context, state) {
        return CustomTextform(
          obscureText: cubit.obscureConfirmText,
          controller: cubit.confirmPassCtrl,
          validator: (value) => AppValidator()
              .confirmPasswordValidator(value, cubit.confirmPassCtrl.text),
          prefixicon: AppIcon.password,
          prefixtext: hintText,
          suffixicon: IconButton(
            onPressed: cubit.toggleObscureConfirm,
            icon: Icon(
              cubit.obscureConfirmText
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
          ),
        );
      },
    );
  }
}
