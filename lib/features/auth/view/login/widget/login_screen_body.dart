import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/widget/custom_firebasebutton.dart';
import 'package:event_planning_app/core/utils/widget/custom_linedtext.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
          ));
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
              //name form
              CustomTextform(
                controller: cubit.nameCtrl,
                validator: (value) => AppValidator().nameValidator(value),
                prefixicon: AppIcon.username,
                prefixtext: AppString.enterName,
              ),
              //pass form
              CustomTextform(
                obscureText: cubit.obscureText,
                controller: cubit.passwordCtrl,
                validator: (value) => AppValidator().passwordValidator(value),
                prefixicon: AppIcon.password,
                prefixtext: AppString.enterPass,
                suffixicon: IconButton(
                  onPressed: cubit.toggleObscure,
                  icon: Icon(
                    cubit.obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
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
              //login button
              if (state is UserLoadingUsername)
                Center(child: const CircularProgressIndicator())
              else
                CustomTextbutton(
                  text: AppString.login,
                  onpressed: () {
                    if (formKey.currentState!.validate()) {
                      cubit.loginWithUsername(
                        username: cubit.nameCtrl.text.trim(),
                        password: cubit.passwordCtrl.text.trim(),
                      );
                    }
                  },
                ),
              const LinedText(text: AppString.or),
              //login with facebook
              if (state is UserLoadingFacebook)
                const Center(child: CircularProgressIndicator())
              else
                CustomFirebasebutton(
                  icon: AppIcon.facebook,
                  text: AppString.logFace,
                  onpressed: cubit.loginWithFacebook,
                ),
              //login with google
              if (state is UserLoadingGoogle)
                Center(child: const CircularProgressIndicator())
              else
                CustomFirebasebutton(
                  icon: AppIcon.google,
                  text: AppString.logGoogle,
                  onpressed: cubit.loginWithGoogle,
                ),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppString.noAcc,
                    style: AppTextStyle.bold14(AppColor.colorbA1),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: Text(
                      AppString.signup,
                      style: AppTextStyle.bold14(AppColor.colorbr80).copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
