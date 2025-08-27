import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/controllers/onboarding_controller.dart';
import 'package:weather_app/routes/app_routes.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(OnboardingController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      _page(
        context,
        'Welcome to Weather',
        'Explore Pakistan’s weather with ease',
        'assets/Clear Day.json', // Lottie animation
      ),
      _page(
        context,
        'City Selection',
        'Pick any city for instant updates',
        'assets/Select Location.json',
      ),
      _page(
        context,
        'Live Weather',
        'Real-time forecasts at your fingertips',
        'assets/Vacation mode.json',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black, // Black background for theme
      body: SafeArea(
        child: Stack(
          children: [
// Main content
            Column(
              children: [
// Skip button at top-right
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: () async {
// Save onboarding completion
// await SharedPreferences.getInstance().setBool('onboarding_seen', true);
                        Get.offAllNamed(AppRoutes.navbar);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
// PageView for onboarding screens
                Expanded(
                  child: PageView.builder(
                    controller: ctrl.pageController,
                    onPageChanged: ctrl.setPage,
                    itemCount: pages.length,
                    itemBuilder: (c, i) => pages[i],
                  ),
                ),
// Dot indicators
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: ctrl.page.value == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: ctrl.page.value == i
                              ? Colors.grey[300]
                              : Colors.grey[700],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
// Next/Get Started button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        if (ctrl.page.value == pages.length - 1) {
// Save onboarding completion
// await SharedPreferences.getInstance().setBool('onboarding_seen', true);
                          Get.offAllNamed(AppRoutes.navbar);
                        } else {
                          ctrl.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.grey[200],
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.4),
                      ),
                      child: Text(
                        ctrl.page.value == pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _page(BuildContext context, String title, String subtitle,
      String animationPath) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
// Lottie animation
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Lottie.asset(
                animationPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  size: 100,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
