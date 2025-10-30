//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_firebasebutton.dart';
import 'package:event_planning_app/features/auth/cubit/cubits/auth_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginButtons extends StatelessWidget {
  final bool isLogin;

  const SocialLoginButtons({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        if (isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CustomCircleProgressInicator(),
          );
        }

        return Column(
          children: [
            // Facebook Button
            CustomFirebasebutton(
              color: AppColor.facebookbutton,
              icon: AppImage.facebook,
              text: AppString.logFace,
              onpressed: () {
                context.read<AuthCubit>().loginWithFacebook();
              },
            ),

            // Google Button
            CustomFirebasebutton(
              color: AppColor.googlebutton,
              icon: AppImage.google,
              text: AppString.logGoogle,
              onpressed: () {
                context.read<AuthCubit>().loginWithGoogle();
              },
            ),
          ],
        );
      },
    );
  }
}
