//ToDo :: Mostafa :: Refactor and Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_linedtext.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/view/register/widget/confirm_password_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_button.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_image.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/email_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/name_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/password_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/redirect_text.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreenBody extends StatelessWidget {
  const RegisterScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    final cubit = BlocProvider.of<UserCubit>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthImage(title: AppString.signup),

            // Use public reusable text fields
            NameTextField(
              cubit: cubit,
              hintText: AppString.fullName,
              controller: cubit.registerNameCtrl,
            ),
            const SizedBox(height: 5),
            EmailTextField(
              cubit: cubit,
              hintText: AppString.emailEx,
              controller: cubit.emailCtrl,
            ),
            const SizedBox(height: 5),
            PasswordTextField(
                cubit: cubit, controller: cubit.registerPasswordCtrl),
            const SizedBox(height: 5),
            ConfirmPasswordTextField(
              cubit: cubit,
              hintText: AppString.confirmPass,
            ),

            SizedBox(height: size.height * 0.03),

            // Use LoginButton but customize for sign-up logic
            LoginButton(
              formKey: formKey,
              buttonText: AppString.signup,
              onLogin: () {
                cubit.signUpWithUsernameAndEmail(
                  username: cubit.registerNameCtrl.text,
                  email: cubit.emailCtrl.text,
                  password: cubit.registerPasswordCtrl.text,
                );
              },
            ),

            // Redirect to login
            RedirectLink(
              questionText: AppString.haveAcc,
              actionText: AppString.login,
              route: '/login',
            ),
          ],
        ),
      ),
    );
  }
}
