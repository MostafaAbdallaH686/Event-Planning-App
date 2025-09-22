//ToDo ::Mostafa::almost done need to send the selections to backend

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:event_planning_app/features/home/cubit/fav_interests_cubit.dart';
import 'package:event_planning_app/features/home/cubit/fav_interests_state.dart';
import 'package:event_planning_app/features/home/data/fav_interests_model.dart';
import 'package:event_planning_app/features/home/data/fav_interests_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestsEventsScreen extends StatelessWidget {
  const InterestsEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InterestsCubit(InterestsRepo(CacheHelper())),
      child: const _InterestsEventsScreenView(),
    );
  }
}

class _InterestsEventsScreenView extends StatelessWidget {
  const _InterestsEventsScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<InterestsCubit, InterestsState>(
          builder: (context, state) {
            if (state is InterestsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is InterestsError) {
              return Center(child: Text(state.message));
            }

            if (state is InterestsLoaded) {
              return _buildContent(context, state);
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, InterestsLoaded state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // final chipWidth = (screenWidth - 64) / 2;

    return Padding(
      padding: EdgeInsets.all(screenWidth * .044444),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * .05),
          // Progress indicator
          _buildProgressIndicator(state.currentStep, screenWidth, screenHeight),
          SizedBox(height: screenHeight * .03),
          // Title
          Text(AppString.favEventsTitle,
              style: AppTextStyle.bold22(AppColor.colorbA1)),
          // Subtitle
          Text(AppString.favEventsSubTitle,
              style: AppTextStyle.regular12(AppColor.colorbr688)),
          SizedBox(height: screenHeight * .02),
          // Categories
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: state.allCategories.map((category) {
                final isSelected = state.isSelected(category.id);
                return _buildCategoryChip(
                  context,
                  category,
                  isSelected,
                  screenWidth,
                  screenHeight,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 5),
          // Finish Button
          CustomTextbutton(
            isIconAdded: true,
            text: 'Finish',
            onpressed: () =>
                context.read<InterestsCubit>().saveAndNavigate(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(
      int currentStep, double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index < currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: screenHeight * .02,
          width: screenWidth * .25,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(screenWidth * .0333),
          ),
        );
      }),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    Category category,
    bool isSelected,
    double screenWidth,
    double screenHeight,
  ) {
    return SizedBox(
      child: GestureDetector(
        onTap: () => context.read<InterestsCubit>().toggleCategory(category),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .038888,
            vertical: screenHeight * .0065,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.blue : AppColor.white,
            borderRadius: BorderRadius.circular(screenWidth * .0333),
            border: Border.all(
              color: isSelected ? AppColor.facebookbutton : AppColor.border,
              width: 1.5,
            ),
          ),
          child: Text(
            category.displayLabel,
            style: AppTextStyle.regular12(
              isSelected ? AppColor.white : AppColor.border,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
