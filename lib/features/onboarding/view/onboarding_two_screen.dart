//Todo: Mostafa Do not Touch Please

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/onboarding/widget/custom_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingSecondScreen extends StatelessWidget {
  const OnboardingSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cacheHelper = CacheHelper();
    cacheHelper.saveData(key: SharedPrefereneceKey.isFirstTime, value: false);

    return CustomOnboarding(
        imagePath: AppImage.onborading2,
        title: AppString.onboardingtitle2,
        onPressed: () {
          context.pushReplacement('/register');
        });
  }
}
