// category_events_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/cubit/search_cubit.dart';
import 'package:event_planning_app/features/home/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryEventsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryEventsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    context.read<SearchCubit>().getEventsByCategory(categoryId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          categoryName,
          style: AppTextStyle.bold20(AppColor.black),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is CategoryEventsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryEventsLoaded) {
            final List<EventModel> events = state.events;
            if (events.isEmpty) {
              return const Center(child: Text("No events found"));
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
                        horizontal: size.width * 0.0307),
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01,
                        horizontal: size.width * 0.0256),
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
                        SizedBox(width: size.width * 0.0307),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.title,
                                  style: AppTextStyle.bold14(AppColor.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              SizedBox(height: size.height * 0.0075),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.grey),
                                  SizedBox(width: size.width * 0.01538),
                                  Text(event.location,
                                      style: AppTextStyle.regular12(
                                          AppColor.colorbr688)),
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
          } else if (state is CategoryEventsError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
