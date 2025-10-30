//ToDo :: Mostafa :: Refactor and Clean Code Please

// ignore_for_file: use_build_context_synchronously

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/features/auth/cubit/cubits/auth_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/states/auth_state.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_button.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_image.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/name_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/password_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/redirect_text.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/social_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/widgets/custom_linedtext.dart';
import 'package:go_router/go_router.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final _formKey = GlobalKey<FormState>();
  // ✅ Controllers managed in UI
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // ✅ Password visibility managed in UI
  bool _isPasswordVisible = false;

  // Server validation errors
  Map<String, String> _serverErrors = {};

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final size = MediaQuery.of(context).size;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          print('✅ Login successful, navigating to home');

          AppToast.success('Welcome, ${state.user.username}!');
          // Navigate to home or favorites based on first-time login
          context.pushReplacement(AppRoutes.navBar);
        } else if (state is AuthError) {
          AppToast.error(state.message);
        } else if (state is AuthValidationError) {
          setState(() {
            _serverErrors = state.errors;
          });
          // Show first error
          if (state.errors.isNotEmpty) {
            AppToast.warning(state.errors.values.first);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            children: [
              AuthImage(title: AppString.login),

              // Email/Username Field
              NameTextField(
                hintText: AppString.enterName,
                controller: _emailController,
                errorText: _serverErrors['email'],
              ),

              // Password Field
              PasswordTextField(
                onToggleVisibility: _togglePasswordVisibility,
                isPasswordVisible: _isPasswordVisible,
                controller: _passwordController,
                errorText: _serverErrors['password'],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.push(AppRoutes.forgetPassword);
                          },
                    child: Text(
                      AppString.forgetPass,
                      style: AppTextStyle.medium14(AppColor.colorbA1),
                    ),
                  ),
                  SizedBox(width: size.height * 0.02),
                ],
              ),

              // Login Button
              LoginButton(
                isaddIcon: true,
                formKey: _formKey,
                buttonText: AppString.login,
                isLoading: isLoading,
                onLogin: () {
                  setState(() => _serverErrors = {});
                  cubit.login(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                },
              ),

              const LinedText(text: AppString.or),

              // Social Login Buttons
              const SocialLoginButtons(isLogin: true),

              SizedBox(height: size.height * 0.02),

              // Redirect to Register
              RedirectLink(
                questionText: AppString.noAcc,
                actionText: AppString.signup,
                route: AppRoutes.register,
              ),
            ],
          ),
        );
      },
    );
  }
}
