import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/auth/view/my_profile/widget/additional_widgets/edit_profile.dart';
import 'package:event_planning_app/features/auth/view/my_profile/widget/additional_widgets/profile_additional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:go_router/go_router.dart';
import 'profile_header.dart';
import 'profile_about.dart';
import 'profile_interests.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 22, color: AppColor.colorb26),
          onPressed: () => context.pop(),
        ),
        title: Text(AppString.profile,
            style: AppTextStyle.semibold22(AppColor.colorb26)),
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoggedOut || state is UserDeletedAccount) {
            context.go(AppRoutes.login);
          }
        },
        builder: (context, state) {
          final isLoading = state is UserLoadingUsername ||
              state is UserLoadingFacebook ||
              state is UserLoadingGoogle ||
              state is UserSigningUp ||
              state is UserResettingPassword ||
              state is UserLoggingOut ||
              state is UserInitial ||
              state is UserLoggingOut ||
              state is UserDeletingAccount;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserDataState) {
            final user = state.user;
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  left: size.width * 0.0533,
                  right: size.width * 0.0855,
                  top: size.height * 0.01875,
                  bottom: size.height * 0.01875),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.00625),
                  ProfileHeader(
                      user: user,
                      onEdit: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(user: user)));
                      },
                      size: size),
                  SizedBox(height: size.height * 0.0375),
                  _Section(
                      child: ProfileAbout(
                    user: user,
                    size: size,
                  )),
                  SizedBox(height: size.height * 0.04),
                  _Section(
                    child: ProfileInterests(
                      user: user,
                      onChange: () {},
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  ProfileAdditional(user: user),
                ],
              ),
            );
          }

          if (state is UserError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColor.colorError, fontSize: 14),
                ),
              ),
            );
          }

          return const Center(
            child: Text(
              AppString.noSession,
              style: TextStyle(fontSize: 14, color: AppColor.black),
            ),
          );
        },
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final Widget child;
  const _Section({required this.child});
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: child,
      );
}
