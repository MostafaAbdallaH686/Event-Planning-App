//ToDo :: MOstafa ::  finishing caching and login logic

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:flutter/material.dart';
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
    _navigateAfterDelay();
  }

// navigate after delay
  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    // ToDo :: MOstafa ::  caching and login logic
    // check cache for first time and login status
    final cacheHelper = CacheHelper();
    final isFirstTime =
        cacheHelper.getData(key: SharedPrefereneceKey.isFirstTime) ?? true;
    final isLoggedIn =
        cacheHelper.getData(key: SharedPrefereneceKey.isLogin) ?? false;
// check if first time or logged in
    if (isFirstTime) {
      await cacheHelper.saveData(
          key: SharedPrefereneceKey.isFirstTime, value: false);
      if (!mounted) return;
      context.pushReplacement(AppRoutes.onBoarding);
    } else if (isLoggedIn) {
      if (!mounted) return;

      context.pushReplacement(AppRoutes.favEvent);
    } else {
      if (!mounted) return;

      context.pushReplacement(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing operations if widget is disposed
    super.dispose();
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
