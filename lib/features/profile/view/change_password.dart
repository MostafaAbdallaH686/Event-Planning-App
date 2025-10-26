import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/features/profile/cubit/profile_cubit.dart';
import 'package:event_planning_app/features/profile/cubit/profile_state.dart';
import 'package:event_planning_app/features/profile/view/widget/change_password_button.dart';
import 'package:event_planning_app/features/profile/view/widget/change_password_field.dart';
import 'package:event_planning_app/features/profile/view/widget/change_password_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends StatelessWidget {
  final UserModel? user;

  const ChangePassword({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final obscureCurrentPassword = ValueNotifier<bool>(true);
    final obscureNewPassword = ValueNotifier<bool>(true);
    final obscureConfirmPassword = ValueNotifier<bool>(true);
    final isLoading = ValueNotifier<bool>(false);

    void changePassword() {
      if (formKey.currentState!.validate()) {
        context.read<ProfileCubit>().changePassword(
              currentPassword: currentPasswordController.text,
              newPassword: newPasswordController.text,
            );
      }
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UserChangedPassword) {
          isLoading.value = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        } else if (state is UserErrorChangePassword) {
          isLoading.value = false;
          AppToast.show(message: state.message);
        } else if (state is UserChangingPassword) {
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
              'Change Password',
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
                ChangePasswordHeader(
                  profileImageUrl: user?.profilePicture,
                ),
                ChangePasswordField(
                  controller: currentPasswordController,
                  hintText: 'Password',
                  obscureNotifier: obscureCurrentPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Current password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ChangePasswordField(
                  controller: newPasswordController,
                  hintText: 'New Password',
                  obscureNotifier: obscureNewPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    if (value == currentPasswordController.text) {
                      return 'New password must be different';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ChangePasswordField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureNotifier: obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                ChangePasswordButton(
                  onPressed: changePassword,
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
