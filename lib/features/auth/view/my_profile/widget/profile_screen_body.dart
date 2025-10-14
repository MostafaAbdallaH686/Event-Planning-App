import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/user_state.dart';
import 'package:go_router/go_router.dart';
import 'profile_header.dart';
import 'profile_about.dart';
import 'profile_interests.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  @override
  void initState() {
    super.initState();
    // Fetch current user if in initial state
    final cubit = context.read<UserCubit>();
    if (cubit.state is UserInitial) {
      cubit.fetchCurrentUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
              state is UserDeletingAccount ||
              state is UserUpdatingPassword;

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
                        context.push(AppRoutes.editProfile, extra: user);
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
                  // ProfileAdditional(user: user),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      if (state is UserLoggingOut) {
                        return const Center(
                            child: CustomCircleProgressInicator());
                      }
                      return CustomTextbutton(
                        onpressed: () {
                          context.read<UserCubit>().logout();
                        },
                        text: 'Logout',
                      );
                    },
                  )
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
