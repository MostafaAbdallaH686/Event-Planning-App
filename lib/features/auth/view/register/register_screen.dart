//ToDo :: Mohnd

import 'package:event_planning_app/features/auth/view/register/widget/register_screen_body.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: const RegisterScreenBody()),
    );
  }
}
