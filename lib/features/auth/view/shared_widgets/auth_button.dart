//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/widget/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String buttonText;
  final Function() onLogin;
  final bool isaddIcon;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.buttonText,
    required this.onLogin,
    this.isaddIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoadingUsername || state is UserSigningUp) {
          return const Center(child: CustomCircleProgressInicator());
        }
        return CustomTextbutton(
          isIconAdded: isaddIcon,
          text: buttonText,
          onpressed: () {
            if (formKey.currentState!.validate()) {
              FocusScope.of(context).unfocus(); // Hide the keyboard
              onLogin();
            }
          },
        );
      },
      listener: (context, state) {
        if (state is UserSignedUp) {
          AppToast.show(message: 'Please Confirm Your Email');
          context.push(AppRoutes.login);
        }
        if (state is UserErrorSignUp) {
          AppToast.show(message: state.message);
        }
      },
    );
  }
}
