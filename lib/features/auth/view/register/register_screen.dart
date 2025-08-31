//ToDo :: Mohnd

import 'package:event_planning_app/core/utils/widget/custom_my_app_bar.dart';
import 'package:event_planning_app/features/auth/view/register/widget/register_screen_body.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: RegisterScreenBody(),
    );
  }
}
