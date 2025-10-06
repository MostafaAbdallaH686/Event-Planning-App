import 'package:event_planning_app/features/onboarding/data/content_model.dart';
import 'package:event_planning_app/features/onboarding/cubit/on_boarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  int? index;
  OnBoardingCubit() : super(OnBoardingState(onboardingContent[0])) {
    index = onboardingContent.indexOf(state.onboardingContent);
  }

  Future<void> nextOnboarding() async {
    if (index! < onboardingContent.length - 1) {
      if (index != null) {
        index = index! + 1;
        emit(OnBoardingState(onboardingContent[index!]));
      }
    }
  }
}
