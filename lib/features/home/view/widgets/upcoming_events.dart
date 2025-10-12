// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/view/widgets/horizontal_event_card.dart';
import 'package:event_planning_app/features/home/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/home_state.dart';
import 'package:go_router/go_router.dart';

class UpcomingEventsSection extends StatelessWidget {
  const UpcomingEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeLoaded) {
          final events = state.data.upcomingEvents;
          if (events.isEmpty) return const SizedBox.shrink();

          final visibleEvents = events.take(5).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: AppString.upcomevent,
                actionText: AppString.all,
                onActionPressed: () {
                  context.push(AppRoutes.seeAllUpComing);
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: visibleEvents.length,
                  itemBuilder: (context, index) {
                    final event = visibleEvents[index];
                    final isJoined = state.joinedEventIds.contains(event.id);
                    return HorizontalEventCard(
                      event: event,
                      isJoined: isJoined,
                      onTap: () {
                        context.push(
                          AppRoutes.eventDetails,
                          extra: {
                            "categoryId": event.categoryId,
                            "eventId": event.id!,
                          },
                        );
                      },
                      onJoinPressed: () {
                        context.read<HomeCubit>().joinEvent(
                              event.categoryId,
                              event.id!,
                            );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
