import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';
import 'package:event_planning_app/features/home/view/widgets/interested_event_button.dart';
import 'package:event_planning_app/features/home/view/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventListSection extends StatelessWidget {
  final String title;
  final String? seeAllRoute;
  final List<EventSummaryModel> events;
  final Set<String> interestedEventIds;
  final void Function(EventSummaryModel event) onEventTap;
  final void Function(EventSummaryModel event) onToggleInterest;

  const EventListSection({
    super.key,
    required this.title,
    this.seeAllRoute,
    required this.events,
    required this.interestedEventIds,
    required this.onEventTap,
    required this.onToggleInterest,
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

            return _EventListTile(
              event: event,
              isInterested: isInterested,
              onTap: () => onEventTap(event),
              onToggleInterest: () => onToggleInterest(event),
            );
          },
        ),
      ],
    );
  }
}

// Event List Tile
class _EventListTile extends StatelessWidget {
  final EventSummaryModel event;
  final bool isInterested;
  final VoidCallback onTap;
  final VoidCallback onToggleInterest;

  const _EventListTile({
    required this.event,
    required this.isInterested,
    required this.onTap,
    required this.onToggleInterest,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: event.imageUrl ?? '',
          width: 70,
          height: 80,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.event),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.event),
          ),
        ),
      ),
      title: Text(
        event.title,
        style: AppTextStyle.bold14(AppColor.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          const Icon(Icons.location_on, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              event.location,
              style: AppTextStyle.regular12(AppColor.colorbr688),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: InterestedEventButton(
        isInterested: isInterested,
        onAdd: onToggleInterest,
        onRemove: onToggleInterest,
        addText: AppString.join,
        removeText: AppString.joined,
        eventId: event.id,
      ),
      onTap: onTap,
    );
  }
}
