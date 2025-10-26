import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_circle_progress_inicator.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/features/profile/cubit/profile_cubit.dart';
import 'package:event_planning_app/features/profile/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'profile_header.dart';
import 'profile_about.dart';
import 'profile_interests.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody>
    with WidgetsBindingObserver {
  UserModel? _lastKnownUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Fetch current user if in initial state
    final cubit = context.read<ProfileCubit>();
    if (cubit.state is ProfileInitial) {
      cubit.fetchCurrentUser();
    } else if (cubit.state is ProfileDataState) {
      _lastKnownUser = (cubit.state as ProfileDataState).user;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   // When app resumes, sync email in case user verified it
  //   if (state == AppLifecycleState.resumed) {
  //     _refreshUserData();
  //   }
  // }

  // void _refreshUserData() {
  //   context.read<ProfileCubit>().syncEmailAfterVerification();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UserLoggedOutEmailChanged) {
            AppToast.show(
                message:
                    'Email changed successfully! Please verify your new email to log in.');
            context.go(AppRoutes.login);
          } else if (state is UserLoggedOut || state is UserDeletedAccount) {
            context.go(AppRoutes.login);
          }
          if (state is ProfileDataState) {
            _lastKnownUser = state.user;
          }
        },
        builder: (context, state) {
          final isLoading =
              state is UserLoggingOut || state is UserDeletingAccount;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Get user from current state or fallback to last known user
          UserModel? user;
          if (state is ProfileDataState) {
            user = state.user;
          } else if (_lastKnownUser != null) {
            user = _lastKnownUser;
          }

          // Show loading if we're fetching user for the first time
          if (user == null && state is ProfileInitial) {
            return const Center(child: CustomCircleProgressInicator());
          }

          if (user != null) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                      onEdit: () async {
                        await context.push(AppRoutes.editProfile, extra: user);
                        // Refresh user data when returning from edit profile
                        // _refreshUserData();
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
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is UserLoggingOut) {
                        return const Center(
                            child: CustomCircleProgressInicator());
                      }
                      return CustomTextbutton(
                        onpressed: () {
                          context.read<ProfileCubit>().logout();
                        },
                        text: 'Logout',
                      );
                    },
                  )
                ],
              ),
            );
          }

          if (state is ProfileError) {
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
