// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/features/profile/cubit/profile_cubit.dart';
import 'package:event_planning_app/features/profile/cubit/profile_state.dart';

import 'package:event_planning_app/features/profile/view/widget/edit_profile_buttons.dart';
import 'package:event_planning_app/features/profile/view/widget/edit_profile_form_fields.dart';
import 'package:event_planning_app/features/profile/view/widget/edit_profile_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController(text: user.username);
    final aboutController = TextEditingController(text: user.about);
    File? selectedImage;

    void saveProfile() {
      if (formKey.currentState!.validate()) {
        // Use cubit to update profile
        context.read<ProfileCubit>().updateProfile(
              username: usernameController.text.trim(),
              about: aboutController.text.trim(),
              profileImage: selectedImage,
            );
      }
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UserUpdatedProfile) {
          AppToast.show(message: 'Profile updated successfully!');
          context.pop();
        } else if (state is UserErrorUpdateProfile) {
          AppToast.show(message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is UserUpdatingProfile;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  size: 20, color: Color(0xFF0D1117)),
              onPressed: () => context.pop(),
            ),
            title: Text('Edit Profile',
                style: AppTextStyle.semibold22(AppColor.colorb26)),
            centerTitle: false,
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              children: [
                EditProfileImage(
                  initialImageUrl: user.profilePicture,
                  username: usernameController.text,
                  onImageSelected: (image) {
                    selectedImage = image;
                  },
                ),
                const SizedBox(height: 40),
                EditProfileFormFields(
                  usernameController: usernameController,
                  aboutController: aboutController,
                  user: user,
                  isLoading: isLoading,
                ),
                const SizedBox(height: 24),
                EditProfileButtons(
                  isLoading: isLoading,
                  onSave: saveProfile,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
