// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:weather_app/controllers/splash_controller.dart';
//
// class SplashView extends GetView<SplashController> {
//   const SplashView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: Colors.black, // Black background for theme
//       body: Center(
//         child: AnimatedOpacity(
//           opacity: 1.0,
//           duration: const Duration(seconds: 2), // 2-second fade-in
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[850],
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.4),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: ClipOval(
//                   child: Lottie.asset(
//                     'assets/Weather.json', // Lottie animation
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       debugPrint('Lottie load error: $error');
//                       return Icon(
//                         Icons.cloud,
//                         size: 80,
//                         color: Colors.grey[300],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Pakistan Weather App',
//                 style: TextStyle(
//                   color: Colors.grey[200],
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'Your Weather, Your Way',
//                 style: TextStyle(
//                   color: Colors.grey[400],
//                   fontSize: 16,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[300]!),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('SplashView: Building at ${DateTime.now()}');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black, // Black background for theme
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(seconds: 2), // 2-second fade-in
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Lottie.asset(
                    'assets/weather.json', // Corrected path
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('SplashView: Lottie load error: $error');
                      return Icon(
                        Icons.cloud,
                        size: 80,
                        color: Colors.grey[300],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pakistan Weather App',
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your Weather, Your Way',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[300]!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}