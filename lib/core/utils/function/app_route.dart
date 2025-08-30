// Mohnd::TODO: Refactor this file to use named routes instead of passing Widget instances directly.

import 'package:event_planning_app/features/auth/view/verification_screen.dart';
import 'package:event_planning_app/features/auth/view/forget_password_screen.dart';
import 'package:event_planning_app/features/auth/view/login/login_screen.dart';
import 'package:event_planning_app/features/auth/view/register/register_screen.dart';
import 'package:event_planning_app/features/home/view/home_screen.dart';
import 'package:event_planning_app/features/onboarding/view/onboarding_screen.dart';
import 'package:event_planning_app/features/onboarding/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
        path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen()),
    GoRoute(
        path: '/forgetpassword',
        builder: (context, state) => const ForgetPasswordScreen()),
    GoRoute(
        path: '/verification',
        builder: (context, state) => const VerificationScreen()),
  ],
);
