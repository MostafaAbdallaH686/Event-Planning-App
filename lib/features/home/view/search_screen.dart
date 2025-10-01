// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:event_planning_app/features/home/cubit/search_cubit.dart';
import 'package:event_planning_app/features/home/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatelessWidget {
  final String searchQuery;
  final TextEditingController _searchController;

  SearchScreen({super.key, required this.searchQuery})
      : _searchController = TextEditingController(text: searchQuery);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // تنفيذ البحث عند فتح الصفحة لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_searchController.text.isNotEmpty) {
        context.read<SearchCubit>().searchEvents(_searchController.text);
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppString.search,
          style: AppTextStyle.bold20(AppColor.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.0307),
            child: CustomTextform(
              controller: _searchController,
              prefixicon: AppIcon.search,
              prefixtext: AppString.search,
              fillColor: AppColor.colorbr9E,
              onChanged: (value) {
                // البحث مباشرة عند الكتابة
                context.read<SearchCubit>().searchEvents(value);
              },
              onFieldSubmitted: (value) {
                // البحث عند الضغط على Enter
                context.read<SearchCubit>().searchEvents(value);
              },
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return Center(child: Text(AppString.starttyping));
                } else if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  final events = state.events;
                  if (events.isEmpty) {
                    return Center(child: Text(AppString.noresult));
                  }
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return InkWell(
                        onTap: () {
                          context.push(
                            AppRoutes.eventDetails,
                            extra: {
                              "categoryId": event.categoryId,
                              "eventId": event.id!,
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: size.width * 0.02,
                            horizontal: size.width * 0.04,
                          ),
                          padding: EdgeInsets.all(size.width * 0.02),
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
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
                              SizedBox(width: size.width * 0.0256),
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
                                    SizedBox(height: size.height * 0.005),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 14, color: Colors.grey),
                                        SizedBox(width: size.width * 0.0102),
                                        Text(
                                          event.location,
                                          style: AppTextStyle.regular12(
                                              AppColor.colorbr688),
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
                } else if (state is SearchError) {
                  return Center(child: Text("❌ ${state.message}"));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
