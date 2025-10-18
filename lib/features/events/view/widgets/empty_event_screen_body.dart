// ignore_for_file: deprecated_member_use, avoid_print

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:event_planning_app/features/events/cubit/interested_cubit.dart';
import 'package:event_planning_app/features/events/cubit/interested_state.dart';
import 'package:event_planning_app/features/events/data/interested_repo.dart';
import 'package:event_planning_app/features/events/view/widgets/event_interested_card.dart';
import 'package:event_planning_app/features/events/view/widgets/segment_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmptyEventScreenBody extends StatefulWidget {
  final String userId;
  const EmptyEventScreenBody({super.key, required this.userId});

  @override
  State<EmptyEventScreenBody> createState() => _EmptyEventScreenBodyState();
}

class _EmptyEventScreenBodyState extends State<EmptyEventScreenBody> {
  int _selectedSegment = 0;
  final List<String> _segments = [AppString.upcoming, AppString.pastEvents];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => InterestedCubit(InterestedRepository(FirestoreService()))
        ..watch(widget.userId),
      child: Column(
        children: [
          SegmentSelector(
            segments: _segments,
            selectedIndex: _selectedSegment,
            onChanged: (index) => setState(() => _selectedSegment = index),
          ),
          Expanded(
            child: BlocBuilder<InterestedCubit, InterestedState>(
              builder: (context, state) {
                if (state is InterestedInitial || state is InterestedLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is InterestedError) {
                  return _buildEmptyInfo(size);
                }

                if (state is InterestedLoaded) {
                  final events =
                      _selectedSegment == 0 ? state.upcoming : state.past;

                  if (events.isEmpty) return _buildEmptyInfo(size);

                  return ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(
                        event: event,
                        onTap: () {
                          context.push(
                            AppRoutes.eventDetails,
                            extra: {
                              "categoryId": event.categoryId,
                              "eventId": event.id,
                            },
                          );
                        },
                      );
                    },
                  );
                }

                return _buildEmptyInfo(size);
              },
            ),
          ),
          CustomTextbutton(
            text: AppString.exploreEvent,
            onpressed: () {},
            isIconAdded: true,
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }

  Widget _buildEmptyInfo(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImage.emptyEvent,
          width: size.width * 0.8125,
          height: size.height * 0.25,
        ),
        Text(
          AppString.noUpcomingEvents,
          style: AppTextStyle.semibold24(AppColor.colorb26),
        ),
        SizedBox(height: size.height * 0.012),
        Text(
          AppString.noResult,
          style: AppTextStyle.regular16(AppColor.colorbr688),
        ),
        SizedBox(height: size.height * 0.024),
      ],
    );
  }
}
