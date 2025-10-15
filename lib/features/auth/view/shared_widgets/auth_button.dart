//ToDO ::Mostafa::Clean Code Please

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/widgets/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String buttonText;
  final VoidCallback onLogin;
  final bool isaddIcon;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.buttonText,
    required this.onLogin,
    this.isaddIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoadingUsername || state is UserSigningUp) {
          return const Center(child: CustomCircleProgressInicator());
        }
        return _LoginActionButton(
          formKey: formKey,
          buttonText: buttonText,
          onLogin: onLogin,
          isaddIcon: isaddIcon,
        );
      },
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
    );
  }

  void _handleStateChanges(BuildContext context, UserState state) {
    if (state is UserSignedUp) {
      AppToast.show(message: 'Please Confirm Your Email');
      if (!context.mounted) return;
      context.push(AppRoutes.login);
      return;
    }

    String? msg;
    if (state is UserErrorSignUp)
      msg = state.message;
    else if (state is UserErrorLoginUsername)
      msg = state.message;
    else if (state is UserErrorLoginFacebook)
      msg = state.message;
    else if (state is UserErrorLoginGoogle)
      msg = state.message;
    else if (state is UserErrorNotVerified)
      msg = state.message;
    else if (state is UserErrorLogout)
      msg = state.message;
    else if (state is UserErrorDeleteAccount)
      msg = state.message;
    else if (state is UserErrorResetPassword)
      msg = state.message;
    else if (state is UserErrorUpdateProfile)
      msg = state.message;
    else if (state is UserErrorVerificationSent) msg = state.message;

    if (msg != null) AppToast.show(message: msg);
  }
}

// Separate widget for the action button
class _LoginActionButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String buttonText;
  final VoidCallback onLogin;
  final bool isaddIcon;

  const _LoginActionButton({
    required this.formKey,
    required this.buttonText,
    required this.onLogin,
    required this.isaddIcon,
  });

  @override
  Widget build(BuildContext context) {
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
