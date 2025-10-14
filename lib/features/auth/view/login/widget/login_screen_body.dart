//ToDo :: Mostafa :: Refactor and Clean Code Please

// ignore_for_file: use_build_context_synchronously

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/widgets/dialogs/app_dialog.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_button.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_image.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/name_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/password_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/redirect_text.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/widgets/custom_linedtext.dart';
import 'package:go_router/go_router.dart';

class LoginScreenBody extends StatelessWidget {
  const LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final cubit = BlocProvider.of<UserCubit>(context);
    final size = MediaQuery.of(context).size;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) async {
        if (state is UserLoggedIn) {
          final isFirstTime = !(await getIt<CacheHelper>()
                  .getData(key: SharedPrefereneceKey.isFirstLogin) ??
              false);
          if (isFirstTime) {
            // Navigate to Interests screen
            context.push(AppRoutes.favEvent);
          } else {
            // Go to Home
            context.pushReplacement(AppRoutes.navBar);
          }
        } else if (state is UserErrorNotVerified) {
          AppDialog.showConfirm(
              context: context,
              title: 'Email Not Verified',
              message: 'Please Verify Your Email',
              confirmText: 'Resend',
              cancelText: 'I did it',
              onConfirm: () {
                cubit.sendVerificationEmail();
                Navigator.of(context).pop();
              });
        } else if (state is UserErrorLoginFacebook ||
            state is UserErrorLoginGoogle ||
            state is UserErrorLoginUsername) {
          AppToast.show(message: (state as UserError).message);
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            children: [
              AuthImage(title: AppString.login),

              // Name Field
              NameTextField(
                cubit: cubit,
                hintText: AppString.enterName,
                controller: cubit.loginNameCtrl,
              ),
              // Password Field
              PasswordTextField(
                  cubit: cubit, controller: cubit.loginPasswordCtrl),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoutes.forgetPassword);
                    },
                    child: Text(
                      AppString.forgetPass,
                      style: AppTextStyle.medium14(AppColor.colorbA1),
                    ),
                  ),
                  SizedBox(width: size.height * 0.02),
                ],
              ),
              // Login Button
              LoginButton(
                isaddIcon: true,
                formKey: formKey,
                buttonText: AppString.login,
                onLogin: () {
                  cubit.loginWithUsername(
                    username: cubit.loginNameCtrl.text.trim(),
                    password: cubit.loginPasswordCtrl.text.trim(),
                  );
                },
              ),
              const LinedText(text: AppString.or),
              // Social Login Buttons
              const SocialLoginButtons(isLogin: true),
              SizedBox(height: size.height * 0.02),
              // Redirect to Register
              RedirectLink(
                questionText: AppString.noAcc,
                actionText: AppString.signup,
                route: AppRoutes.register,
              ),
            ],
          ),
        );
      },
    );
  }
}
