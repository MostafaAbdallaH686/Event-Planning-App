//ToDo :: Mohnd

import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/auth/cubit/cubits/auth_cubit.dart';
import 'package:event_planning_app/features/auth/view/register/widget/register_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        loginUseCase: getIt(),
        registerUseCase: getIt(),
        loginWithGoogleUseCase: getIt(),
        loginWithFacebookUseCase: getIt(),
        logoutUseCase: getIt(),
        getCurrentUserUseCase: getIt(),
      ),
      child: const Scaffold(
        body: RegisterScreenBody(),
      ),
    );
  }
}
