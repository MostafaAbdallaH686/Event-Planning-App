import 'package:event_planning_app/features/events/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';

class EventInfoSection extends StatelessWidget {
  final EventModel event;

  const EventInfoSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          event.title,
          style: AppTextStyle.bold35(AppColor.colorb26),
        ),
        SizedBox(height: size.height * 0.01),

        // Category badge
        if (event.category != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.colorbl83,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              event.category!.name,
              style: AppTextStyle.medium12(AppColor.colorbr688),
            ),
          ),
        SizedBox(height: size.height * 0.015),

        // Date & Time
        _InfoRow(
          icon: AppIcon.date,
          title: DateFormat("dd MMM, yyyy").format(event.dateTime),
          subtitle:
              "${DateFormat('EEEE').format(event.dateTime)}, ${DateFormat('h:mm a').format(event.dateTime)}",
        ),
        SizedBox(height: size.height * 0.01),

        // Location
        _InfoRow(
          icon: AppIcon.location,
          title: event.location,
          subtitle: event.location,
        ),
        SizedBox(height: size.height * 0.01),

        // Attendees info
        _InfoRow(
          icon: AppIcon.username,
          title:
              '${event.registrationsCount} / ${event.maxAttendees} attendees',
          subtitle: event.isFull
              ? 'Event is full'
              : '${event.availableSpots} spots available',
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: size.width * 0.1230,
          height: size.height * 0.06,
        ),
        SizedBox(width: size.width * 0.03589),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.semibold16(AppColor.colorb26),
              ),
              Text(
                subtitle,
                style: AppTextStyle.medium12(AppColor.colorbr688),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
