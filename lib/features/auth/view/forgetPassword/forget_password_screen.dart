//ToDO ::Hadeer

import 'package:event_planning_app/core/utils/widget/custom_my_app_bar.dart';
import 'package:event_planning_app/features/auth/view/forgetPassword/widget/forget_screen_body.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: ForgetScreenBody(),
    );
  }
}
