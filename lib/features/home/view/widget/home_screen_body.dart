// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.02),

              /// 🔍 Search Box
              CustomTextform(
                fillColor: AppColor.colorbr9E,
                prefixicon: AppIcon.search,
                prefixtext: AppString.search,
                suffixicon: Padding(
                  padding: EdgeInsets.only(right: size.width * 0.055555555556),
                  child: SvgPicture.asset(
                    AppIcon.filter,
                    height: size.height * 0.03,
                    width: size.width * 0.0666666667,
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.025),

              /// 🔹 Categories + Upcoming Events
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else if (state is HomeLoaded) {
                    final categories = state.categories;
                    final upcomingEvents = state.upcomingEvents;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ================= Categories =================
                        if (categories.isNotEmpty)
                          SizedBox(
                            height: size.height * 0.05,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                final categoryName =
                                    (category["name"] ?? "No name").toString();
                                final categoryIcon =
                                    (category["icon"] ?? "").toString();
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      categoryIcon.isNotEmpty
                                          ? Image.network(
                                              categoryIcon,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.category),
                                            )
                                          : const Icon(Icons.category),
                                      const SizedBox(width: 5),
                                      Text(
                                        categoryName,
                                        style: AppTextStyle.regular14(
                                            AppColor.colorbA1),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                        SizedBox(height: size.height * 0.05),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppString.upcomevent,
                              style: AppTextStyle.bold16(AppColor.colorbA1),
                            ),
                            const Spacer(),
                            Text(
                              AppString.all,
                              style:
                                  AppTextStyle.semibold14(AppColor.colorbr80),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (upcomingEvents.isNotEmpty)
                          SizedBox(
                            height: size.height * 0.14,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: upcomingEvents.length,
                              itemBuilder: (context, index) {
                                final event = upcomingEvents[index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                        width: size.width * 0.252777,
                                        height: size.height * 0.105,
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                event.imageUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            event.title,
                                            style: AppTextStyle.bold16(
                                                AppColor.colorbA1),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on,
                                                  size: 14, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                event.location,
                                                style: AppTextStyle.regular12(
                                                    AppColor.colorbr688),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              BlocBuilder<HomeCubit, HomeState>(
                                                builder: (context, state) {
                                                  if (state is HomeLoaded) {
                                                    final isJoined = state
                                                        .joinedEventIds
                                                        .contains(event.id);

                                                    return Container(
                                                      width: size.width *
                                                          0.1972222222,
                                                      height:
                                                          size.height * 0.0425,
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColor.colorbr80,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: TextButton(
                                                        onPressed: isJoined
                                                            ? null
                                                            : () {
                                                                context
                                                                    .read<
                                                                        HomeCubit>()
                                                                    .joinEvent(
                                                                        event
                                                                            .id!);
                                                              },
                                                        child: Text(
                                                          isJoined
                                                              ? AppString.joined
                                                              : AppString.join,
                                                          style: AppTextStyle
                                                              .regular12(
                                                                  AppColor
                                                                      .white),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return const SizedBox
                                                      .shrink();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
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
              ),
              SizedBox(height: size.height * 0.015),

              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppString.populr,
                              style: AppTextStyle.bold16(AppColor.colorbA1),
                            ),
                            const Spacer(),
                            Text(
                              AppString.all,
                              style:
                                  AppTextStyle.semibold14(AppColor.colorbr80),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),

                        // ✅ Popular Events ListView
                        SizedBox(
                          height: size.height * 0.35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.popularEvents.length,
                            itemBuilder: (context, index) {
                              final event = state.popularEvents[index];
                              final isJoined =
                                  state.joinedEventIds.contains(event.id);

                              return Container(
                                width: size.width * 0.7,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColor.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: size.height * 0.225,
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.title,
                                          style: AppTextStyle.bold14(
                                              AppColor.black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              event.location,
                                              style: AppTextStyle.regular12(
                                                  AppColor.colorbr80),
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: isJoined
                                                  ? null
                                                  : () {
                                                      context
                                                          .read<HomeCubit>()
                                                          .joinEvent(event.id!);
                                                    },
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    AppColor.colorbr80,
                                                minimumSize: const Size(80, 30),
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
              ),
              Row(
                children: [
                  Text(
                    AppString.recommendation,
                    style: AppTextStyle.bold16(AppColor.colorbA1),
                  ),
                  const Spacer(),
                  Text(
                    AppString.all,
                    style: AppTextStyle.semibold14(AppColor.colorbr80),
                  ),
                ],
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else if (state is HomeLoaded) {
                    final recommendedEvents = state.recommendedEvents;

                    if (recommendedEvents.isEmpty) {
                      return const Center(
                        child: Text("No recommendations available"),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recommendedEvents.length,
                      itemBuilder: (context, index) {
                        final event = recommendedEvents[index];
                        final isJoined =
                            state.joinedEventIds.contains(event.id);

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
                              // صورة الحدث
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

                              // العنوان + المكان + زرار join
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style:
                                          AppTextStyle.bold14(AppColor.black),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                                            Text(
                                              event.location,
                                              style: AppTextStyle.regular12(
                                                  AppColor.colorbr688),
                                            ),
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
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
