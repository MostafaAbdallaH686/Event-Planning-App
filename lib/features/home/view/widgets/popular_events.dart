// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/core/utils/utils/app_distance.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/view/widgets/event_card.dart';
import 'package:event_planning_app/features/home/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/home_state.dart';
import 'package:go_router/go_router.dart';

class PopularEventsSection extends StatelessWidget {
  const PopularEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeLoading() => const _LoadingView(),
          HomeLoaded(:final data, :final joinedEventIds)
              when data.popularEvents.isNotEmpty =>
            _PopularEventsContent(
              events: data.popularEvents,
              joinedEventIds: joinedEventIds,
            ),
          HomeError(:final message) => _ErrorView(message: message),
          _ => const _EmptyView(),
        };
      },
    );
  }
}

// Loading state
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// Error state
class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $message',
        style: AppTextStyle.regular12(Colors.red),
      ),
    );
  }
}

// Empty state
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No popular events available',
        style: AppTextStyle.regular12(AppColor.colorbr80),
      ),
    );
  }
}

// Content with events
class _PopularEventsContent extends StatelessWidget {
  final List<EventModel> events;
  final Set<String> joinedEventIds;

  const _PopularEventsContent({
    required this.events,
    required this.joinedEventIds,
  });

  @override
  Widget build(BuildContext context) {
    final displayEvents = events.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppString.populr,
          actionText: AppString.all,
          onActionPressed: () => context.push(AppRoutes.seeAllPopular),
        ),
        SizedBox(
            height:
                AppWidthHeight.percentageOfHeight(context, AppDistance.d10)),
        SizedBox(
          height: AppWidthHeight.percentageOfHeight(context, AppDistance.d190),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayEvents.length,
            itemBuilder: (context, index) => _buildEventCard(
              context,
              displayEvents[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event) {
    final isInterested = joinedEventIds.contains(event.id);

    return EventCard(
      event: event,
      isInterested: isInterested,
      onAddInterest: () => context.read<HomeCubit>().toggleInterestEvent(
            categoryId: event.categoryId,
            eventId: event.id!,
            event: event,
          ),
      onRemoveInterest: () => context.read<HomeCubit>().toggleInterestEvent(
            categoryId: event.categoryId,
            eventId: event.id!,
            event: event,
          ),
      onTap: () => _navigateToDetails(context, event),
    );
  }

  void _navigateToDetails(BuildContext context, EventModel event) {
    context.push(
      AppRoutes.eventDetails,
      extra: {
        "categoryId": event.categoryId,
        "eventId": event.id!,
      },
    );
  }
}
