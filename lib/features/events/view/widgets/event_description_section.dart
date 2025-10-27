import 'package:event_planning_app/features/events/data/models/event_model.dart';
import 'package:event_planning_app/features/events/view/widgets/expandable_description.dart';
import 'package:flutter/material.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';

class EventDescriptionSection extends StatelessWidget {
  final EventModel event;

  const EventDescriptionSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          AppString.aboutEvent,
          style: AppTextStyle.semibold18(AppColor.colorbr688),
        ),
        SizedBox(height: size.height * 0.015),

        // Organizer info
        if (event.organizer != null) ...[
          _OrganizerCard(organizer: event.organizer!),
          SizedBox(height: size.height * 0.015),
        ],

        // Event description
        ExpandableDescription(
          description: event.description,
          textStyle: AppTextStyle.light16(AppColor.black),
          linkStyle: AppTextStyle.light16(AppColor.blue),
        ),

        // Event status badge
        SizedBox(height: size.height * 0.015),
        _StatusBadge(status: event.status, isUpcoming: event.isUpcoming),
      ],
    );
  }
}

class _OrganizerCard extends StatelessWidget {
  final OrganizerInfo organizer;

  const _OrganizerCard({required this.organizer});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Organizer avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColor.border,
            child: Text(
              organizer.username[0].toUpperCase(),
              style: AppTextStyle.bold16(Colors.white),
            ),
          ),
          SizedBox(width: size.width * 0.03),

          // Organizer info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organized by',
                  style: AppTextStyle.regular12(AppColor.colorbr688),
                ),
                Text(
                  organizer.username,
                  style: AppTextStyle.bold14(AppColor.colorb26),
                ),
              ],
            ),
          ),

          // Follow button
          OutlinedButton(
            onPressed: () {
              // TODO: Implement follow organizer
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Follow'),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final bool isUpcoming;

  const _StatusBadge({
    required this.status,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'SCHEDULED':
        bgColor = isUpcoming ? Colors.green.shade100 : Colors.grey.shade100;
        textColor = isUpcoming ? Colors.green.shade700 : Colors.grey.shade700;
        displayText = isUpcoming ? 'Upcoming' : 'Past Event';
        break;
      case 'CANCELLED':
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        displayText = 'Cancelled';
        break;
      case 'COMPLETED':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        displayText = 'Completed';
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: AppTextStyle.medium12(textColor),
      ),
    );
  }
}
