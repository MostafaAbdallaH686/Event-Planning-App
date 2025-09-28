// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/home_state.dart';
import 'package:go_router/go_router.dart';

class UpcomingEventsSection extends StatelessWidget {
  const UpcomingEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoaded && state.upcomingEvents.isNotEmpty) {
          final events = state.upcomingEvents;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(AppString.upcomevent,
                      style: AppTextStyle.bold16(AppColor.colorbA1)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.push('/SeeAllUpComing');
                    },
                    child: Text(AppString.all,
                        style: AppTextStyle.semibold14(AppColor.colorbr80)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: size.height * 0.14,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length > 5 ? 5 : events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final isJoined = state.joinedEventIds.contains(event.id);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.25,
                            height: size.height * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(event.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: size.width * 0.45,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(event.title,
                                    style:
                                        AppTextStyle.bold16(AppColor.colorbA1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(event.location,
                                          style: AppTextStyle.regular12(
                                              AppColor.colorbr688),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Container(
                                      height: size.height * 0.04,
                                      decoration: BoxDecoration(
                                        color: AppColor.colorbr80,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextButton(
                                        onPressed: isJoined
                                            ? null
                                            : () {
                                                context
                                                    .read<HomeCubit>()
                                                    .joinEvent(event.id!,
                                                        event.categoryId);
                                              },
                                        child: Text(
                                          isJoined
                                              ? AppString.joined
                                              : AppString.join,
                                          style: AppTextStyle.regular12(
                                              AppColor.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
