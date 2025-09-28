// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/home_state.dart';
import 'package:go_router/go_router.dart';

class RecommendedEventsSection extends StatelessWidget {
  const RecommendedEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoaded && state.recommendedEvents.isNotEmpty) {
          final events = state.recommendedEvents;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(AppString.recommendation,
                      style: AppTextStyle.bold16(AppColor.colorbA1)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.push('/SeeAllRecommendation');
                    },
                    child: Text(AppString.all,
                        style: AppTextStyle.semibold14(AppColor.colorbr80)),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length > 5 ? 5 : events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  final isJoined = state.joinedEventIds.contains(event.id);
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: size.width * 0.02),
                    padding: EdgeInsets.all(size.width * 00.01),
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
                                  style: AppTextStyle.bold14(AppColor.black),
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
                                    onPressed: isJoined
                                        ? null
                                        : () {
                                            context.read<HomeCubit>().joinEvent(
                                                event.id!, event.categoryId);
                                          },
                                    style: TextButton.styleFrom(
                                      backgroundColor: AppColor.colorbr80,
                                      minimumSize: Size(size.width * 0.17948,
                                          size.height * 0.0375),
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
