//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widget/custom_firebasebutton.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SocialLoginButtons extends StatelessWidget {
  final bool isLogin;

  const SocialLoginButtons({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserLoggedIn) {
              context.go('/home');
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserLoadingFacebook) {
              return const Center(child: CustomCircleProgressInicator());
            }
            return CustomFirebasebutton(
              icon: AppIcon.facebook,
              text: AppString.logFace,
              onpressed: () => context.read<UserCubit>().loginWithFacebook(),
            );
          },
        ),
        BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserLoggedIn) {
              context.go('/home');
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserLoadingGoogle) {
              return const Center(child: CustomCircleProgressInicator());
            }
            return CustomFirebasebutton(
              icon: AppIcon.google,
              text: AppString.logGoogle,
              onpressed: () => context.read<UserCubit>().loginWithGoogle(),
            );
          },
        ),
      ],
    );
  }
}
