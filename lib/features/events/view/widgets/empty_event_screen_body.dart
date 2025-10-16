// ignore_for_file: dead_code, deprecated_member_use, avoid_print

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_radius.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:event_planning_app/features/events/cubit/events_cubit.dart';
import 'package:event_planning_app/features/events/cubit/events_state.dart';
import 'package:event_planning_app/features/events/data/events_repo.dart';
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
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.041, horizontal: size.width * 0.09),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.black.withOpacity(.0287),
                borderRadius: AppRadius.segmentsRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: List.generate(_segments.length, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSegment = index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedSegment == index
                                ? AppColor.white
                                : Colors.transparent,
                            borderRadius: AppRadius.segmentsRadius,
                            boxShadow: _selectedSegment == index
                                ? [
                                    BoxShadow(
                                      color: AppColor.black.withOpacity(0.1),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    )
                                  ]
                                : null,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.014),
                          child: Text(
                            _segments[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: _selectedSegment == index
                                  ? AppColor.black
                                  : AppColor.colorbr9B,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // content
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
                  print(
                      "✅ Loaded events: ${state.events.length}, Upcoming: ${state.upcoming.length}, Past: ${state.past.length}");
                  final events =
                      _selectedSegment == 0 ? state.upcoming : state.past;

                  if (events.isEmpty) return _buildEmptyInfo(size);

                  return ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.06),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final isJoined = true; // all are interested => joined
                      return InkWell(
                        onTap: () {
                          // navigate to event details (uses go_router)
                          context.push(
                            AppRoutes.eventDetails,
                            extra: {
                              "categoryId": event.categoryId,
                              "eventId": event.id,
                            },
                          );
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: size.width * 0.02),
                          padding: EdgeInsets.all(size.width * 0.01),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.256410,
                                height: size.height * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(event.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: size.width * 0.03076),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(event.title,
                                        style:
                                            AppTextStyle.bold14(AppColor.black),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: size.height * 0.01),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on,
                                                size: 14, color: Colors.grey),
                                            SizedBox(width: size.width * 0.01),
                                            Text(event.location,
                                                style: AppTextStyle.regular12(
                                                    AppColor.colorbr688)),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: isJoined ? null : () {},
                                          style: TextButton.styleFrom(
                                            backgroundColor: AppColor.colorbr80,
                                            minimumSize: Size(
                                                size.width * 0.17948,
                                                size.height * 0.0375),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            isJoined
                                                ? AppString.joined
                                                : AppString.join,
                                            style: AppTextStyle.regular12(
                                                AppColor.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
