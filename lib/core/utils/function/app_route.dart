// Mohnd::TODO: Refactor this file to use named routes instead of passing Widget instances directly.

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
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
import 'package:event_planning_app/features/profile/view/change_email.dart';
import 'package:event_planning_app/features/profile/view/change_password.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:event_planning_app/features/order/view/booking_cancel_screen.dart';
import 'package:event_planning_app/features/order/view/cancel_booking_screen.dart';
import 'package:event_planning_app/features/order/view/order_details_screen.dart';
import 'package:event_planning_app/features/order/view/ticket_booked_screen.dart';
import 'package:event_planning_app/features/order/view/view_ticket_screen.dart';
import 'package:event_planning_app/features/profile/view/edit_profile.dart';
import 'package:event_planning_app/features/profile/view/profile_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(FirebaseAnalytics analytics) {
  return GoRouter(
    initialLocation: '/splash',
    observers: [FirebaseAnalyticsObserver(analytics: analytics)],
    routes: [
      GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          name: 'register',
          path: '/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          name: 'home',
          path: '/home',
          builder: (context, state) => const HomeScreen()),
      GoRoute(
          name: 'splash',
          path: '/splash',
          builder: (context, state) => SplashScreen(
                cacheHelper: getIt<CacheHelper>(),
              )),
      GoRoute(
          name: 'favEvent',
          path: '/favEvent',
          builder: (context, state) => const InterestsEventsScreen()),
      GoRoute(
          name: 'onboarding',
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen()),
      GoRoute(
          name: 'forgetpassword',
          path: '/forgetpassword',
          builder: (context, state) => const ForgetPasswordScreen()),
      GoRoute(
          name: 'verification',
          path: '/verification',
          builder: (context, state) => const VerificationScreen()),
      GoRoute(
          name: 'mapView',
          path: '/mapView',
          builder: (context, state) => const MapViewScreen()),
      GoRoute(
          name: 'emptyEvent',
          path: '/emptyEvent',
          builder: (context, state) => const EmptyEventScreen()),
      GoRoute(
          name: 'navigationBar',
          path: '/navigationBar',
          builder: (context, state) => const MainNavigation()),
      GoRoute(
          name: 'createEvent',
          path: '/createEvent',
          builder: (context, state) => const CreateEventScreen()),
      GoRoute(
          name: 'SeeAllRecommendation',
          path: '/SeeAllRecommendation',
          builder: (context, state) => const SeeAllRecommendationScreen()),
      GoRoute(
          name: 'SeeAllPopular',
          path: '/SeeAllPopular',
          builder: (context, state) => const SeeAllPopularScreen()),
      GoRoute(
          name: 'SeeAllUpComing',
          path: '/SeeAllUpComing',
          builder: (context, state) => const SeeAllUpComingScreen()),
      GoRoute(
        name: 'search',
        path: '/SearchScreen',
        builder: (context, state) {
          final query = state.extra as String?;
          return SearchScreen(searchQuery: query ?? '');
        },
      ),
      GoRoute(
        name: 'eventDetails',
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
        name: 'categoryEvents',
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
          name: 'profile',
          path: '/profile',
          builder: (context, state) => const ProfileScreen()),
      GoRoute(
        name: 'editProfile',
        path: '/editProfile',
        builder: (context, state) {
          final userData = state.extra as UserModel;
          return EditProfileScreen(user: userData);
        },
      ),
      GoRoute(
        name: 'changeEmail',
        path: '/changeEmail',
        builder: (context, state) {
          final userData = state.extra as UserModel;
          return ChangeEmailScreen(user: userData);
        },
      ),
      GoRoute(
        name: 'changePasswordProfile',
        path: '/changePasswordProfile',
        builder: (context, state) {
          final userData = state.extra as UserModel;
          return ChangePassword(user: userData);
        },
      ),
      GoRoute(
        name: 'bookingCancel',
        path: '/bookingCancel',
        builder: (context, state) => const BookingCancelScreen(),
      ),
      GoRoute(
        name: 'cancelBooking',
        path: '/cancelBooking',
        builder: (context, state) => const CancelBookingScreen(),
      ),
      GoRoute(
        name: 'orderDetails',
        path: '/orderDetails',
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return OrderDetailsScreen(order: order);
        },
      ),
      GoRoute(
        name: 'ticketBooked',
        path: '/ticketBooked',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final order = extra['order'] as OrderModel;

          return TicketBookedScreen(
            order: order,
            seat: extra['seat'],
            qrImageUrl: extra['qrImageUrl'],
          );
        },
      ),
      GoRoute(
        name: 'viewTicket',
        path: '/viewTicket',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final OrderModel order = extra['order'] as OrderModel;
          final String seat = extra['seat'] as String;
          final String qrImageUrl = extra['qrImageUrl'] as String;

          return ViewTicketScreen(
            order: order,
            seat: seat,
            qrImageUrl: qrImageUrl,
          );
        },
      ),
    ],
  );
}
