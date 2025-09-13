import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/home_state.dart';

class RecommendedEventsSection extends StatelessWidget {
  const RecommendedEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded && state.recommendedEvents.isNotEmpty) {
          final events = state.recommendedEvents;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(AppString.recommendation,
                      style: AppTextStyle.bold16(AppColor.colorbA1)),
                  const Spacer(),
                  Text(AppString.all,
                      style: AppTextStyle.semibold14(AppColor.colorbr80)),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final isJoined = state.joinedEventIds.contains(event.id);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(event.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title,
                                  style: AppTextStyle.bold14(AppColor.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(event.location,
                                          style: AppTextStyle.regular12(
                                              AppColor.colorbr688)),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: isJoined
                                        ? null
                                        : () {
                                            context
                                                .read<HomeCubit>()
                                                .joinEvent(event.id!);
                                          },
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColor.colorbr80,
                                      minimumSize: const Size(70, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
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
                  );
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
