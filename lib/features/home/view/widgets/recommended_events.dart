// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/view/widgets/event_list_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/home_state.dart';
import 'package:go_router/go_router.dart';

class RecommendedEventsSection extends StatelessWidget {
  const RecommendedEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeLoaded && state.data.recommendedEvents.isNotEmpty) {
          return EventListSection(
            title: AppString.recommendation,
            seeAllRoute: AppRoutes.seeAllRecommendation,
            events: state.data.recommendedEvents,
            joinedEventIds: state.joinedEventIds,
            onEventTap: (event) => context.push(
              AppRoutes.eventDetails,
              extra: {"categoryId": event.categoryId, "eventId": event.id!},
            ),
            onJoin: (event) => context.read<HomeCubit>().joinEvent(
                  event.categoryId,
                  event.id!,
                ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
