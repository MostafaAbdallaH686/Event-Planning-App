// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
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
    final size = MediaQuery.of(context).size;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoaded && state.popularEvents.isNotEmpty) {
          final events = state.popularEvents;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(AppString.populr,
                      style: AppTextStyle.bold16(AppColor.colorbA1)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoutes.seeAllPopular);
                    },
                    child: Text(AppString.all,
                        style: AppTextStyle.semibold14(AppColor.colorbr80)),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              SizedBox(
                height: size.height * 0.38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length > 5 ? 5 : events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final isJoined = state.joinedEventIds.contains(event.id);

                    return Container(
                      width: size.width * 0.7,
                      margin: EdgeInsets.only(right: size.width * 0.0256),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: size.height * 0.22,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(event.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.0205,
                                vertical: size.height * 0.009),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.title,
                                    style: AppTextStyle.bold14(AppColor.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(event.location,
                                        style: AppTextStyle.regular12(
                                            AppColor.colorbr80)),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: isJoined
                                          ? null
                                          : () {
                                              context
                                                  .read<HomeCubit>()
                                                  .joinEvent(event.categoryId,
                                                      event.id!);
                                            },
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColor.colorbr80,
                                        minimumSize: Size(size.width * 0.2051,
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
                    );
                  },
                ),
              ),
            ],
          );
        } else {}
        return const SizedBox.shrink();
      },
    );
  }
}
