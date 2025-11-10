//ToDo :: MOstafa ::  finishing caching and login logic

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/auth/cubit/cubits/auth_cubit.dart';
import 'package:event_planning_app/features/auth/cubit/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay();
    });
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final cacheHelper = getIt<CacheHelper>();
    final isFirstTime =
        cacheHelper.getData(key: SharedPrefereneceKey.isFirstTime) ?? true;

    if (isFirstTime) {
      await cacheHelper.saveData(
          key: SharedPrefereneceKey.isFirstTime, value: false);
      if (!mounted) return;
      context.go('/onboarding');
      return;
    }

    // Check auth with AuthCubit
    await context.read<AuthCubit>().checkAuthStatus();

    if (!mounted) return;

    final authState = context.read<AuthCubit>().state;

    if (authState is AuthAuthenticated) {
      context.go('/navigationBar');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset(AppImage.splashLogo),
              Image.asset(AppImage.splash),
            ],
          ),
        ],
      ),
    );
  }
}
