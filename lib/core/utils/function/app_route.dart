// Mohnd::TODO: Refactor this file to use named routes instead of passing Widget instances directly.
import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/auth/view/verification/verification_screen.dart';
import 'package:event_planning_app/features/auth/view/forgetPassword/forget_password_screen.dart';
import 'package:event_planning_app/features/auth/view/login/login_screen.dart';
import 'package:event_planning_app/features/auth/view/register/register_screen.dart';
import 'package:event_planning_app/features/events/view/create_event_screen.dart';
import 'package:event_planning_app/features/events/view/empty_event_screen.dart';
import 'package:event_planning_app/features/events/view/event_details_screen.dart';
import 'package:event_planning_app/features/events/view/map_view_screen.dart';
import 'package:event_planning_app/features/home/cubit/cubits/search_cubit.dart';
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
import 'package:event_planning_app/features/profile/view/edit_profile.dart';
import 'package:event_planning_app/features/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ✅ CREATE A FUNCTION INSTEAD
GoRouter createRouter() {
  print('🔵 Creating GoRouter...');

  try {
    final router = GoRouter(
      initialLocation: '/splash',
      debugLogDiagnostics: true, // ✅ Enable this

      // Add error handler
      errorBuilder: (context, state) {
        print('🔴 Router Error: ${state.error}');
        return Scaffold(
          appBar: AppBar(title: const Text('Navigation Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text('Error: ${state.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        );
      },

      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) {
            print('🔵 Building LoginScreen');
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) {
            print('🔵 Building RegisterScreen');
            return const RegisterScreen();
          },
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) {
            print('🔵 Building HomeScreen');
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/splash',
          builder: (context, state) {
            print('🔵 Building SplashScreen');
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: '/favEvent',
          builder: (context, state) => const InterestsEventsScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/forgetpassword',
          builder: (context, state) => const ForgetPasswordScreen(),
        ),
        GoRoute(
          path: '/verification',
          builder: (context, state) => const VerificationScreen(),
        ),
        GoRoute(
          path: '/mapView',
          builder: (context, state) => const MapViewScreen(),
        ),
        GoRoute(
          path: '/emptyEvent',
          builder: (context, state) => const EmptyEventScreen(),
        ),
        GoRoute(
          path: '/navigationBar',
          builder: (context, state) => const MainNavigation(),
        ),
        GoRoute(
          path: '/createEvent',
          builder: (context, state) => const CreateEventScreen(),
        ),
        GoRoute(
          path: '/SeeAllRecommendation',
          builder: (context, state) => const SeeAllRecommendationScreen(),
        ),
        GoRoute(
          path: '/SeeAllPopular',
          builder: (context, state) => const SeeAllPopularScreen(),
        ),
        GoRoute(
          path: '/SeeAllUpComing',
          builder: (context, state) => const SeeAllUpComingScreen(),
        ),
        GoRoute(
          path: '/SearchScreen',
          name: 'SearchScreen',
          builder: (context, state) {
            final query = (state.extra as String?) ?? '';
            return BlocProvider(
              create: (context) => SearchCubit(getIt()),
              child: SearchScreen(searchQuery: query),
            );
          },
        ),
        GoRoute(
          path: '/eventDetails/:id',
          builder: (context, state) {
            final eventId = state.pathParameters['id'] ?? '';

            print('🔍 EventDetails route called');
            print('   Path params: ${state.pathParameters}');
            print('   Extra: ${state.extra}');
            print('   Extracted eventId: "$eventId"');

            if (eventId.isEmpty) {
              print('⚠️ Event ID is empty!');
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning, size: 64, color: Colors.orange),
                      const SizedBox(height: 16),
                      const Text('No event ID provided'),
                      const SizedBox(height: 8),
                      Text('Path params: ${state.pathParameters}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        child: const Text('Go Home'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return EventDetailsScreen(eventId: eventId);
          },
        ),
        GoRoute(
          path: '/categoryEvents/:id/:name',
          builder: (context, state) {
            final categoryId = state.pathParameters['id'] ?? '';
            final categoryName = state.pathParameters['name'] ?? '';
            return CategoryEventsScreen(
              categoryId: categoryId,
              categoryName: categoryName,
            );
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/editProfile',
          builder: (context, state) {
            final userData = state.extra as UserModel?;
            if (userData == null) {
              return const Scaffold(
                body: Center(child: Text('User data required')),
              );
            }
            return EditProfileScreen(user: userData);
          },
        ),
      ],
    );

    print('✅ GoRouter created successfully!');
    return router;
  } catch (e, stack) {
    print('🔴🔴🔴 ERROR CREATING ROUTER:');
    print('Error: $e');
    print('Stack: $stack');
    rethrow;
  }
}
