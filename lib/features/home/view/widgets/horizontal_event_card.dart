// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';
import 'package:event_planning_app/features/home/view/widgets/interested_event_button.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HorizontalEventCard extends StatelessWidget {
  final EventSummaryModel event;
  final VoidCallback onTap;
  final bool isInterested;
  final VoidCallback onAddInterest;
  final VoidCallback onRemoveInterest;

  const HorizontalEventCard({
    super.key,
    required this.event,
    required this.isInterested,
    required this.onAddInterest,
    required this.onRemoveInterest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: size.width * 0.85, // Card width
        margin: EdgeInsets.only(right: size.width * 0.0205),
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.008,
          horizontal: size.width * 0.0256,
        ),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: event.imageUrl ?? '',
                width: size.width * 0.25,
                height: size.height * 0.09,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.event, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.0205),

            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: AppTextStyle.bold16(AppColor.colorbA1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.005),

                  // Location & Join Button
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppTextStyle.regular12(AppColor.colorbr688),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InterestedEventButton(
                        isInterested: isInterested,
                        onAdd: onAddInterest,
                        onRemove: onRemoveInterest,
                        addText: AppString.join,
                        removeText: AppString.joined,
                        size: Size(size.width * 0.2051, size.height * 0.0375),
                        eventId: event.id,
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
