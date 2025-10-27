// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/cubit/cubits/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/states/home_state.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';
import 'package:event_planning_app/features/home/domain/entities/home_data.dart';
import 'package:event_planning_app/features/home/view/widgets/event_card.dart';
import 'package:event_planning_app/features/home/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:go_router/go_router.dart';

class PopularEventsSection extends StatelessWidget {
  const PopularEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeLoading() => const _LoadingView(),
          HomeLoaded(:final data) when data.popularEvents.isNotEmpty =>
            _PopularEventsContent(state: data),
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
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// Error state
class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Error: $message',
          style: AppTextStyle.regular12(Colors.red),
        ),
      ),
    );
  }
}

// Empty state
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

// Content with events
class _PopularEventsContent extends StatelessWidget {
  final HomeData state;

  const _PopularEventsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final displayEvents = state.popularEvents.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppString.populr,
          actionText: AppString.all,
          onActionPressed: () => context.push(AppRoutes.seeAllPopular),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
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

  Widget _buildEventCard(BuildContext context, EventSummaryModel event) {
    final isInterested = state.joinedEventIds.contains(event.id);

    return EventCard(
      event: event,
      isInterested: isInterested,
      onAddInterest: () =>
          context.read<HomeCubit>().toggleInterestEvent(event.id),
      onRemoveInterest: () =>
          context.read<HomeCubit>().toggleInterestEvent(event.id),
      onTap: () => _navigateToDetails(context, event),
    );
  }

  void _navigateToDetails(BuildContext context, EventSummaryModel event) {
    context.push(
      AppRoutes.eventDetails,
      extra: {"eventId": event.id},
    );
  }
}
