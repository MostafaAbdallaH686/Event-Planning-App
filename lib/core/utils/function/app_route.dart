// Mohnd::TODO: Refactor this file to use named routes instead of passing Widget instances directly.

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/auth/view/my_profile/edit_profile.dart';
import 'package:event_planning_app/features/auth/view/my_profile/profile_screen.dart';
import 'package:event_planning_app/features/auth/view/verification/verification_screen.dart';
import 'package:event_planning_app/features/auth/view/forgetPassword/forget_password_screen.dart';
import 'package:event_planning_app/features/auth/view/login/login_screen.dart';
import 'package:event_planning_app/features/auth/view/register/register_screen.dart';
import 'package:event_planning_app/features/events/view/empty_event_screen.dart';
import 'package:event_planning_app/features/events/view/event_details_screen.dart';
import 'package:event_planning_app/features/events/view/map_view_screen.dart';
import 'package:event_planning_app/features/home/view/category_events_screen.dart';
import 'package:event_planning_app/features/home/view/home_screen.dart';
import 'package:event_planning_app/features/home/view/interests_events_screen.dart';
import 'package:event_planning_app/features/home/view/search_screen.dart';
import 'package:event_planning_app/features/home/view/see_all_popular.dart';
import 'package:event_planning_app/features/home/view/see_all_recommendation_screen.dart';
import 'package:event_planning_app/features/home/view/see_all_upcoming_screen.dart';
import 'package:event_planning_app/core/utils/widgets/navigation_bar.dart';
import 'package:event_planning_app/features/onboarding/view/onboarding_screen.dart';
import 'package:event_planning_app/features/onboarding/view/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
        path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(
              cacheHelper: getIt<CacheHelper>(),
            )),
    GoRoute(
        path: '/favEvent',
        builder: (context, state) => const InterestsEventsScreen()),
    GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen()),
    GoRoute(
        path: '/forgetpassword',
        builder: (context, state) => const ForgetPasswordScreen()),
    GoRoute(
        path: '/verification',
        builder: (context, state) => const VerificationScreen()),
    GoRoute(
        path: '/mapView', builder: (context, state) => const MapViewScreen()),
    GoRoute(
        path: '/emptyEvent',
        builder: (context, state) => const EmptyEventScreen()),
    GoRoute(
        path: '/navigationBar',
        builder: (context, state) => const MainNavigation()),
    GoRoute(
        path: '/SeeAllRecommendation',
        builder: (context, state) => const SeeAllRecommendationScreen()),
    GoRoute(
        path: '/SeeAllPopular',
        builder: (context, state) => const SeeAllPopularScreen()),
    GoRoute(
        path: '/SeeAllUpComing',
        builder: (context, state) => const SeeAllUpComingScreen()),
    GoRoute(
      path: '/SearchScreen',
      builder: (context, state) {
        final query = state.extra as String?;
        return SearchScreen(searchQuery: query ?? '');
      },
    ),
    GoRoute(
      path: '/eventDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        final categoryId = extra?['categoryId'] as String? ?? '';
        final eventId = extra?['eventId'] as String? ?? '';

        return EventDetailsScreen(
          categoryId: categoryId,
          eventId: eventId,
        );
      },
    ),
    GoRoute(
      path: '/categoryEvents/:id/:name',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        final categoryName = state.pathParameters['name']!;
        return CategoryEventsScreen(
          categoryId: categoryId,
          categoryName: categoryName,
        );
      },
    ),
    GoRoute(
        path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
      path: '/editProfile',
      builder: (context, state) {
        final userData = state.extra as UserModel;
        return EditProfileScreen(user: userData);
      },
    )
  ],
);
