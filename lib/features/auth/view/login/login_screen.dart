//ToDo :: Mohnd

import 'package:event_planning_app/features/auth/view/login/widget/login_screen_body.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: const LoginScreenBody()));
  }
}
