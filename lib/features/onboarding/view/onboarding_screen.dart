//ToDo :: Mostafa :: Do not Touch Please

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/onboarding/cubit/on_boarding_cubit.dart';
import 'package:event_planning_app/features/onboarding/cubit/on_boarding_state.dart';
import 'package:event_planning_app/features/onboarding/view/widgets/custom_onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late ValueNotifier<int> indexNotifier;
  late int finalIndex = 0;

  @override
  void initState() {
    super.initState();
    indexNotifier = ValueNotifier<int>(0);
    indexNotifier.addListener(() {
      setState(() {
        finalIndex = indexNotifier.value;
      });
    });
  }

  void _completeOnboarding(BuildContext context) async {
    final cacheHelper = getIt<CacheHelper>();
    await cacheHelper.saveData(
      key: SharedPrefereneceKey.isFirstTime,
      value: false,
    );

    if (!context.mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<OnBoardingCubit>();
    indexNotifier.value = cubit.index ?? 0;
  }

  @override
  void dispose() {
    indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: CustomOnboarding(
              index: indexNotifier.value,
              key: ValueKey<int>(indexNotifier.value),
              buttonText: indexNotifier.value == 2
                  ? AppString.signup
                  : AppString.onboardingbtn,
              imagePath: state.onboardingContent.image,
              title: state.onboardingContent.title,
              onPressed: () async {
                if (indexNotifier.value == 2) {
                  _completeOnboarding(context);
                  return;
                }
                context.read<OnBoardingCubit>().nextOnboarding();
                indexNotifier.value = context.read<OnBoardingCubit>().index!;
              },
            ),
          );
        },
      ),
    );
  }
}
