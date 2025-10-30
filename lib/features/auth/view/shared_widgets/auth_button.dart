//ToDO ::Mostafa::Clean Code Please

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:event_planning_app/core/utils/widgets/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';

import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String buttonText;
  final VoidCallback onLogin;
  final bool isLoading;
  final bool isaddIcon;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.buttonText,
    required this.onLogin,
    this.isLoading = false,
    this.isaddIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: CustomCircleProgressInicator(),
        ),
      );
    }

    return CustomTextbutton(
      isIconAdded: isaddIcon,
      text: buttonText,
      onpressed: () => _handlePress(context),
    );
  }

  void _handlePress(BuildContext context) {
    // Safe validation
    if (formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      onLogin();
    }
  }
}
