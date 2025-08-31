import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/utils/app_validator.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgetScreenBody extends StatefulWidget {
  const ForgetScreenBody({super.key});

  @override
  State<ForgetScreenBody> createState() => _ForgetScreenBodyState();
}

class _ForgetScreenBodyState extends State<ForgetScreenBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02777),
        child: Column(
          children: [
            Text(
              AppString.forgetPass,
              style: AppTextStyle.bold24(AppColor.colorbA1),
            ),
            Text(
              AppString.forgetDesc,
              style: AppTextStyle.extraLight15(AppColor.black),
            ),
            SizedBox(
              height: size.height * 0.06,
            ),
            CustomTextform(
              controller: _emailCtrl,
              validator: (value) => AppValidator().emailValidator(value),
              prefixicon: AppIcon.mail,
              prefixtext: AppString.emailEx,
            ),
            SizedBox(height: size.height * 0.05),
            CustomTextbutton(
                text: AppString.send,
                onpressed: () {
                  if (_formKey.currentState!.validate()) {
                    // firebase code  will be  here
                    context.go('/verification');
                  }
                })
          ],
        ),
      )),
    );
  }
}
