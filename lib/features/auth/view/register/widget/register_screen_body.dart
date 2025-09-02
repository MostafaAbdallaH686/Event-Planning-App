import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widget/custom_firebasebutton.dart';
import 'package:event_planning_app/core/utils/widget/custom_linedtext.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreenBody extends StatefulWidget {
  const RegisterScreenBody({super.key});

  @override
  State<RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<RegisterScreenBody> {
  bool _obscure = true;
  bool _obscureConfirmPass = true;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  AppString.signup,
                  style: AppTextStyle.bold24(AppColor.colorbA1),
                ),
              ],
            ),
            CustomTextform(
                controller: _nameCtrl,
                validator: (value) => AppValidator().nameValidator(value),
                prefixicon: AppIcon.username,
                prefixtext: AppString.fullName),
            CustomTextform(
                controller: _emailCtrl,
                validator: (value) => AppValidator().emailValidator(value),
                prefixicon: AppIcon.mail,
                prefixtext: AppString.emailEx),
            CustomTextform(
              obscureText: _obscure,
              controller: _passwordCtrl,
              validator: (value) => AppValidator().passwordValidator(value),
              prefixicon: AppIcon.password,
              prefixtext: AppString.yourPass,
              suffixicon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            CustomTextform(
              obscureText: _obscureConfirmPass,
              controller: _confirmPassCtrl,
              validator: (value) => AppValidator()
                  .confirmPasswordValidator(value, _passwordCtrl.text),
              prefixicon: AppIcon.password,
              prefixtext: AppString.confirmPass,
              suffixicon: IconButton(
                onPressed: () =>
                    setState(() => _obscureConfirmPass = !_obscureConfirmPass),
                icon: Icon(
                  _obscureConfirmPass ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),

            BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserSignedUp) {
                  context.go('/login');
                } else if (state is UserError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  ));
                }
              },
              builder: (context, state) {
                if (state is UserSigningUp) {
                  return Center(child: CircularProgressIndicator());
                }
                return CustomTextbutton(
                    text: AppString.signup,
                    onpressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<UserCubit>().signUpWithUsernameAndEmail(
                            username: _nameCtrl.text,
                            email: _emailCtrl.text,
                            password: _passwordCtrl.text);
                      }
                    });
              },
            ),
            SizedBox(width: size.height * 0.01),
            LinedText(
              text: AppString.or,
            ),
            //login with facebook
            BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserLoggedIn) {
                  context.pushReplacement('/home');
                } else if (state is UserError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  ));
                }
              },
              builder: (context, state) {
                if (state is UserLoadingFacebook) {
                  return Center(child: const CircularProgressIndicator());
                }
                return CustomFirebasebutton(
                  icon: AppIcon.facebook,
                  text: AppString.logFace,
                  onpressed: () {
                    context.read<UserCubit>().loginWithFacebook();
                  },
                );
              },
            ),
            //login with google
            BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserLoggedIn) {
                  context.pushReplacement('/home');
                } else if (state is UserError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  ));
                }
              },
              builder: (context, state) {
                if (state is UserLoadingGoogle) {
                  return const CircularProgressIndicator();
                }
                return CustomFirebasebutton(
                  icon: AppIcon.google,
                  text: AppString.logGoogle,
                  onpressed: () {
                    context.read<UserCubit>().loginWithGoogle();
                  },
                );
              },
            ),
            SizedBox(height: size.height * 0.02),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                AppString.haveAcc,
                style: AppTextStyle.bold14(AppColor.colorbA1),
              ),
              TextButton(
                onPressed: () {
                  context.pushReplacement('/login');
                },
                child: Text(
                  AppString.login,
                  style: AppTextStyle.bold14(AppColor.colorbr80).copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
