// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/cubit/cubits/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/states/home_state.dart';
import 'package:event_planning_app/features/home/view/widgets/event_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:go_router/go_router.dart';

class RecommendedEventsSection extends StatelessWidget {
  const RecommendedEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoaded) return const SizedBox.shrink();
        if (state.data.recommendedEvents.isEmpty)
          return const SizedBox.shrink();

        return EventListSection(
          title: AppString.recommendation,
          seeAllRoute: AppRoutes.seeAllRecommendation,
          events: state.data.recommendedEvents,
          interestedEventIds: state.data.joinedEventIds,
          onEventTap: (event) => context.push(
            AppRoutes.eventDetails,
            extra: {"eventId": event.id},
          ),
          onToggleInterest: (event) =>
              context.read<HomeCubit>().toggleInterestEvent(event.id),
        );
      },
    );
  }
}
