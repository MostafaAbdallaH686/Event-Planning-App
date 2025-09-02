//ToDo :: Mostafa :: Refactor and Clean Code Please

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_button.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/name_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/password_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/redirect_text.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/widget/custom_linedtext.dart';
import 'package:go_router/go_router.dart';

class LoginScreenBody extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  LoginScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<UserCubit>(context);
    final size = MediaQuery.of(context).size;

    return BlocConsumer<UserCubit, UserState>(
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
        return Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            children: [
              SizedBox(height: size.height * 0.038),
              Container(
                width: double.infinity,
                height: size.height * 0.20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImage.splash),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                AppString.welcome,
                style: AppTextStyle.bold24(AppColor.black),
              ),
              Text(
                textAlign: TextAlign.center,
                AppString.describtion,
                style: AppTextStyle.medium14(AppColor.colorbA1),
              ),
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
                      context.go('/forgetpassword');
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
                route: '/register',
              ),
            ],
          ),
        );
      },
    );
  }
}
