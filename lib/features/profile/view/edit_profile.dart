import 'dart:io';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/profile/cubit/profile_cubit.dart';
import 'package:event_planning_app/features/profile/cubit/profile_state.dart';

import 'package:event_planning_app/features/profile/view/widget/edit_profile_buttons.dart';
import 'package:event_planning_app/features/profile/view/widget/edit_profile_form_fields.dart';
import 'package:event_planning_app/features/profile/view/widget/edit_profile_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _aboutController;

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _aboutController = TextEditingController(text: widget.user.about);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  void _onImageSelected(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Use cubit to update profile
      context.read<ProfileCubit>().updateProfile(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            about: _aboutController.text.trim(),
            profileImage: _selectedImage,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UserUpdatingProfile) {
          setState(() => _isLoading = true);
        } else if (state is UserUpdatedProfile) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) Navigator.pop(context, state.user);
          });
        } else if (state is UserErrorUpdateProfile) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                size: 20, color: Color(0xFF0D1117)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Edit Profile',
              style: AppTextStyle.semibold22(AppColor.colorb26)),
          centerTitle: false,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.height * 0.02,
            ),
            children: [
              EditProfileImage(
                initialImageUrl: widget.user.profilePicture,
                username: _usernameController.text,
                onImageSelected: _onImageSelected,
              ),
              const SizedBox(height: 40),
              EditProfileFormFields(
                usernameController: _usernameController,
                emailController: _emailController,
                aboutController: _aboutController,
              ),
              const SizedBox(height: 24),
              EditProfileButtons(
                isLoading: _isLoading,
                onSave: _saveProfile,
                onCancel: () => Navigator.pop(context),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
