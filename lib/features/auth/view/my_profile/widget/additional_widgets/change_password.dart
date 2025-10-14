import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: SafeArea(
        child: BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserErrorUpdatePassword) {
              AppToast.show(message: state.message);
            }
            if (state is UserUpdatedPassword) {
              AppToast.show(message: "Password updated successfully");
              Navigator.pop(context);
            }
          },
          child: Column(
            children: [
              TextField(
                  controller: oldController,
                  decoration: InputDecoration(labelText: "old")),
              TextField(
                  controller: newController,
                  decoration: InputDecoration(labelText: "New")),
              OutlinedButton(
                  onPressed: () {
                    context.read<UserCubit>().updatePassword(
                        oldPassword: oldController.text,
                        newPassword: newController.text);
                  },
                  child: Text("Change Password")),
            ],
          ),
        ),
      ),
    );
  }
}
