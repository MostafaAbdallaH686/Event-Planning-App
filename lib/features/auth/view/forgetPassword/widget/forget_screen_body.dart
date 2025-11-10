//ToDo :: Mostafa :: Refactor Please and Clean Code Please

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/features/auth/cubit/cubits/auth_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetScreenBody extends StatelessWidget {
  const ForgetScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    final cubit = BlocProvider.of<AuthCubit>(context);
    final formKey = GlobalKey<FormState>();

    final size = MediaQuery.of(context).size;
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03777),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03777),
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    AppString.forgetPass,
                    style: AppTextStyle.bold24(AppColor.colorbA1),
                  ),
                  Text(
                    textAlign: TextAlign.start,
                    AppString.forgetDesc,
                    style: AppTextStyle.extraLight15(AppColor.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            EmailTextField(
              controller: emailController,
              errorText: null,
              hintText: AppString.emailEx,
            ),
            SizedBox(height: size.height * 0.05),
            BlocConsumer<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserResetPasswordSent) {
                  AppToast.show(message: 'Email sent successfully');
                } else if (state is UserErrorResetPassword) {
                  AppToast.show(message: state.message);
                }
              },
              builder: (context, state) {
                if (state is UserResettingPassword) {
                  return Center(child: CustomCircleProgressInicator());
                }
                return CustomTextbutton(
                    text: AppString.send,
                    onpressed: () {
                      // if (formKey.currentState!.validate()) {
                      //   cubit.resetPassword(email: cubit.forgetPemailCtrl.text);
                      // }
                    });
              },
            )
          ],
        ),
      )),
    );
  }
}
