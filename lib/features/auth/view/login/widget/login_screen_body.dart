import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widget/custom_firebasebutton.dart';
import 'package:event_planning_app/core/utils/widget/custom_linedtext.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  bool _obscure = true;
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
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
          children: [
            //picture
            SvgPicture.asset(
              AppIcon.tAppicon,
              width: double.infinity,
              height: size.height * 0.30,
            ),
            Text(
              AppString.welcome,
              style: AppTextStyle.bold24(AppColor.black),
            ),
            SizedBox(height: size.height * 0.025),
            Text(
              AppString.describtion,
              style: AppTextStyle.reg14(AppColor.colorbA1),
            ),
            //name form
            CustomTextform(
              controller: _nameCtrl,
              validator: (value) => AppValidator().nameValidator(value),
              prefixicon: AppIcon.username,
              prefixtext: AppString.enterName,
            ),
            //pass form
            CustomTextform(
              obscureText: _obscure,
              controller: _passwordCtrl,
              validator: (value) => AppValidator().passwordValidator(value),
              prefixicon: AppIcon.password,
              prefixtext: AppString.enterPass,
              suffixicon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    context.go('/forgetpassword');
                  },
                  child: Text(
                    AppString.forgetPass,
                    style: AppTextStyle.reg14(AppColor.colorbA1),
                  ),
                ),
                SizedBox(width: size.height * 0.02),
              ],
            ),
            SizedBox(height: size.height * 0.025),
            //login button
            CustomTextbutton(
                text: AppString.login,
                onpressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.go('/home');
                  }
                }),
            SizedBox(width: size.height * 0.01),
            LinedText(
              text: AppString.or,
            ),
            //login with facebook
            CustomFirebasebutton(
                icon: AppIcon.facebook, text: AppString.logFace),
            //login with google
            CustomFirebasebutton(
                icon: AppIcon.google, text: AppString.logGoogle),
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
                    style: AppTextStyle.bold14(AppColor.colorbr80),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
