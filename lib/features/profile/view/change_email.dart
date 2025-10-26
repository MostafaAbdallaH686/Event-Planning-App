import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/profile/cubit/profile_cubit.dart';
import 'package:event_planning_app/features/profile/cubit/profile_state.dart';
import 'package:event_planning_app/features/profile/view/widget/change_email_button.dart';
import 'package:event_planning_app/features/profile/view/widget/change_email_field.dart';
import 'package:event_planning_app/features/profile/view/widget/change_email_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangeEmailScreen extends StatelessWidget {
  final UserModel user;

  const ChangeEmailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final currentEmailController = TextEditingController(text: user.email);
    final newEmailController = TextEditingController();
    final passwordController = TextEditingController();

    final obscurePassword = ValueNotifier<bool>(true);
    final isLoading = ValueNotifier<bool>(false);

    void changeEmail() {
      if (formKey.currentState!.validate()) {
        context.read<ProfileCubit>().changeEmail(
              currentEmail: currentEmailController.text.trim(),
              newEmail: newEmailController.text.trim(),
              password: passwordController.text,
            );
      }
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UserChangedEmail) {
          isLoading.value = false;
          AppToast.show(
              message:
                  'Email changed successfully! Please verify your new email to log in.');
          context.go(AppRoutes.login);
        } else if (state is UserErrorChangeEmail) {
          isLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        } else if (state is UserChangingEmail) {
          isLoading.value = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xFF0D1117),
              ),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Change Email',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D1B2A),
              ),
            ),
            centerTitle: false,
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                const SizedBox(height: 20),
                // Info text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue.shade700, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Important: Your email will only be updated after you verify the new email address. We will send a verification link to your new email.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Current Email Field
                const Text(
                  'Current Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D1B2A),
                  ),
                ),
                const SizedBox(height: 8),
                ChangeEmailField(
                  controller: currentEmailController,
                  hintText: 'Current email address',
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Current email is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // New Email Field
                const Text(
                  'New Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D1B2A),
                  ),
                ),
                const SizedBox(height: 8),
                ChangeEmailField(
                  controller: newEmailController,
                  hintText: 'Enter new email address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    if (value == currentEmailController.text) {
                      return 'New email must be different from current email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Password Field
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D1B2A),
                  ),
                ),
                const SizedBox(height: 8),
                ChangeEmailPasswordField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  obscureNotifier: obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                // Update Button
                ChangeEmailButton(
                  onPressed: changeEmail,
                  isLoadingNotifier: isLoading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
