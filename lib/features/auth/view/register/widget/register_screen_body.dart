//ToDo :: Mostafa :: Refactor and Clean Code Please

import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/auth/cubit/cubits/auth_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/states/auth_state.dart';
import 'package:event_planning_app/features/auth/view/register/widget/confirm_password_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_button.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/auth_image.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/email_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/name_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/password_text_field.dart';
import 'package:event_planning_app/features/auth/view/shared_widgets/redirect_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreenBody extends StatefulWidget {
  const RegisterScreenBody({super.key});

  @override
  State<RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<RegisterScreenBody> {
  final _formKey = GlobalKey<FormState>();
  // ✅ Controllers managed in UI
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  // ✅ Password visibility managed in UI
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Map<String, String> _serverErrors = {};

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = context.read<AuthCubit>();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          print('✅ Registration successful, navigating to interests');

          AppToast.success('Account created successfully!');
          // Navigate to interests or home
          context.pushReplacement(AppRoutes.favEvent);
        } else if (state is AuthError) {
          AppToast.error(state.message);
        } else if (state is AuthValidationError) {
          setState(() {
            _serverErrors = state.errors;
          });
          if (state.errors.isNotEmpty) {
            AppToast.warning(state.errors.values.first);
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthImage(title: AppString.signup),

                // Username Field
                NameTextField(
                  hintText: AppString.fullName,
                  controller: _usernameController,
                  errorText: _serverErrors['username'],
                ),
                const SizedBox(height: 5),

                // Email Field
                EmailTextField(
                  hintText: AppString.emailEx,
                  controller: _emailController,
                  errorText: _serverErrors['email'],
                ),
                const SizedBox(height: 5),

                // Password Field
                PasswordTextField(
                  isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: _togglePasswordVisibility,
                  controller: _passwordController,
                  errorText: _serverErrors['password'],
                ),
                const SizedBox(height: 5),

                // Confirm Password Field
                ConfirmPasswordTextField(
                  controller: _confirmPasswordController,
                  passwordController: _passwordController,
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: _toggleConfirmPasswordVisibility,
                  hintText: AppString.confirmPass,
                  errorText: _serverErrors['confirmPassword'],
                ),

                SizedBox(height: size.height * 0.03),

                // Register Button
                LoginButton(
                  formKey: _formKey,
                  buttonText: AppString.signup,
                  isLoading: isLoading,
                  onLogin: () {
                    setState(() => _serverErrors = {});
                    cubit.register(
                      username: _usernameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      confirmPassword: _confirmPasswordController.text.trim(),
                      role: 'ATTENDEE', // or allow user to select
                    );
                  },
                ),

                // Redirect to login
                RedirectLink(
                  questionText: AppString.haveAcc,
                  actionText: AppString.login,
                  route: AppRoutes.login,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
