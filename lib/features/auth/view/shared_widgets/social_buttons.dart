//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widget/custom_firebasebutton.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
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
              context.pushReplacement(AppRoutes.navBar);
            } else if (state is UserErrorLoginFacebook) {
              AppToast.show(message: state.message);
            }
          },
          builder: (context, state) {
            if (state is UserLoadingFacebook) {
              return const Center(child: CustomCircleProgressInicator());
            }
            return CustomFirebasebutton(
              color: AppColor.facebookbutton,
              icon: AppImage.facebook,
              text: AppString.logFace,
              onpressed: () => context.read<UserCubit>().loginWithFacebook(),
            );
          },
        ),
        BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserLoggedIn) {
              context.pushReplacement(AppRoutes.navBar);
            } else if (state is UserErrorLoginGoogle) {
              AppToast.show(message: state.message);
            }
          },
          builder: (context, state) {
            if (state is UserLoadingGoogle) {
              return const Center(child: CustomCircleProgressInicator());
            }
            return CustomFirebasebutton(
              color: AppColor.googlebutton,
              icon: AppImage.google,
              text: AppString.logGoogle,
              onpressed: () => context.read<UserCubit>().loginWithGoogle(),
            );
          },
        ),
      ],
    );
  }
}
