import 'package:get/get.dart';
import 'package:weather_app/controllers/splash_controller.dart';
import 'package:weather_app/routes/app_routes.dart';
import 'package:weather_app/views/auth/onboarding_view.dart';
import 'package:weather_app/views/auth/splash_view.dart';
import 'package:weather_app/views/home/weather_view.dart';
import 'package:weather_app/views/main_nav.dart';





class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingView(),
      // binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.weather,
      page: () => WeatherView(),
      // binding: WeatherBinding(),
    ),
    GetPage(
      name: AppRoutes.navbar,
      page: () => MainNav(),
      // binding: WeatherBinding(),
    ),
  ];
}
