// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/features/events/data/interested_model.dart';
import 'package:event_planning_app/features/home/view/widgets/interested_event_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';

class EventCard extends StatelessWidget {
  final InterestedEvent event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isJoined = true; // منطقك الحالي لكل الـ interested events

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: size.width * 0.02),
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
                      style: AppTextStyle.bold14(AppColor.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          SizedBox(width: size.width * 0.01),
                          Text(event.location,
                              style:
                                  AppTextStyle.regular12(AppColor.colorbr688)),
                        ],
                      ),
                      InterestedEventButton(
                        isInterested: isJoined,
                        eventId: event.id,
                        onAdd: () {
                          context.read<HomeCubit>().toggleInterestEvent(
                                categoryId: event.categoryId,
                                eventId: event.id,
                                event: event.toEventModel(),
                              );
                        },
                        onRemove: () {
                          context.read<HomeCubit>().toggleInterestEvent(
                                categoryId: event.categoryId,
                                eventId: event.id,
                                event: event.toEventModel(),
                              );
                        },
                        addText: AppString.join,
                        removeText: AppString.joined,
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
  }
}
