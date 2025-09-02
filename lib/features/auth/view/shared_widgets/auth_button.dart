//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/widget/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String buttonText;
  final Function() onLogin;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.buttonText,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoadingUsername || state is UserSigningUp) {
          return const Center(child: CustomCircleProgressInicator());
        }
        return CustomTextbutton(
          text: buttonText,
          onpressed: () {
            if (formKey.currentState!.validate()) {
              onLogin();
            }
          },
        );
      },
      listener: (context, state) {
        if (state is UserSignedUp) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signed up successfully')),
          );
          context.push('/login');
        }
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    );
  }
}
