import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/core/utils/widgets/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/profile/cubit/profile_cubit.dart';
import 'package:event_planning_app/features/profile/cubit/profile_state.dart';

import 'package:event_planning_app/features/profile/view/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAdditional extends StatelessWidget {
  final UserModel user;
  const ProfileAdditional({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is UserErrorLogout) {
                AppToast.show(message: state.message);
              }
            },
            builder: (context, state) {
              if (state is UserLoggingOut) {
                return const Center(child: CustomCircleProgressInicator());
              }
              return OutlinedButton(
                  onPressed: () {
                    context.read<ProfileCubit>().logout();
                  },
                  child: const Text("Logout"));
            },
          ),
          BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is UserErrorDeleteAccount) {
                AppToast.show(message: state.message);
              }
            },
            builder: (context, state) {
              if (state is UserDeletingAccount) {
                return const Center(child: CustomCircleProgressInicator());
              }
              return OutlinedButton(
                  onPressed: () {
                    context.read<ProfileCubit>().deleteAccount();
                  },
                  child: const Text("Delete Account"));
            },
          ),
          OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePassword()));
              },
              child: const Text("Change Password")),
        ],
      ),
    );
  }
}
