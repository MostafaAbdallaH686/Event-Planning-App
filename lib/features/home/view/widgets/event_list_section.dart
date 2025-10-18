import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/view/widgets/interested_event_button.dart';
import 'package:event_planning_app/features/home/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventListSection extends StatelessWidget {
  final String title;
  final String? seeAllRoute;
  final List<EventModel> events;
  final Set<String> interestedEventIds;
  final void Function(EventModel event) onEventTap;
  final void Function(EventModel event) onAddInterest;
  final void Function(EventModel event) onRemoveInterest;

  const EventListSection({
    super.key,
    required this.title,
    this.seeAllRoute,
    required this.events,
    required this.interestedEventIds,
    required this.onEventTap,
    required this.onAddInterest,
    required this.onRemoveInterest,
  });

  @override
  Widget build(BuildContext context) {
    final visibleEvents = events.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionText: seeAllRoute != null ? AppString.all : null,
          onActionPressed:
              seeAllRoute != null ? () => context.push(seeAllRoute!) : null,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleEvents.length,
          itemBuilder: (context, index) {
            final event = visibleEvents[index];
            final isInterested = interestedEventIds.contains(event.id);
            return ListTile(
              leading: event.imageUrl.isNotEmpty
                  ? Image.network(
                      event.imageUrl,
                      width: AppWidthHeight.percentageOfWidth(context, 70),
                      height: AppWidthHeight.percentageOfHeight(context, 80),
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.event, size: 50),
              title: Text(event.title,
                  style: AppTextStyle.bold14(AppColor.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              subtitle: Row(
                children: [
                  Flexible(
                    child: Text(event.location,
                        style: AppTextStyle.regular12(AppColor.colorbr688),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const Spacer(),
                  InterestedEventButton(
                    isInterested: isInterested,
                    onAdd: () => onAddInterest(event),
                    onRemove: () => onRemoveInterest(event),
                    addText: AppString.join,
                    removeText: AppString.joined,
                    eventId: event.id!,
                  ),
                ],
              ),
              onTap: () => onEventTap(event),
            );
          },
        ),
      ],
    );
  }
}
