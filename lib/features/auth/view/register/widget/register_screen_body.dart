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
import 'package:go_router/go_router.dart';

class RegisterScreenBody extends StatefulWidget {
  const RegisterScreenBody({super.key});

  @override
  State<RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<RegisterScreenBody> {
  bool _obscure = true;
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
            Text(
              AppString.signup,
              style: AppTextStyle.bold24(AppColor.colorbA1),
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
              controller: _confirmPassCtrl,
              validator: (value) => AppValidator()
                  .confirmPasswordValidator(value, _passwordCtrl.text),
              prefixicon: AppIcon.password,
              prefixtext: AppString.confirmPass,
              suffixicon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),

            CustomTextbutton(
                text: AppString.signup,
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                AppString.haveAcc,
                style: AppTextStyle.bold14(AppColor.colorbA1),
              ),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text(
                  AppString.login,
                  style: AppTextStyle.bold14(AppColor.colorbr80),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
