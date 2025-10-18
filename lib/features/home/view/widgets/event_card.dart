// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_distance.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/view/widgets/interested_event_button.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final bool isInterested;
  final VoidCallback onAddInterest;
  final VoidCallback onRemoveInterest;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.isInterested,
    required this.onAddInterest,
    required this.onRemoveInterest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: AppWidthHeight.percentageOfWidth(context, AppDistance.d220),
        margin: EdgeInsets.only(
            right: AppWidthHeight.percentageOfWidth(context, AppDistance.d10)),
        decoration: _cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EventImage(imageUrl: event.imageUrl),
            _EventDetails(
              event: event,
              isInterested: isInterested,
              onAddInterest: onAddInterest,
              onRemoveInterest: onRemoveInterest,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(
          AppWidthHeight.percentageOfHeight(context, AppDistance.d12)),
      color: AppColor.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(
            .2,
          ),
          blurRadius:
              AppWidthHeight.percentageOfHeight(context, AppDistance.d6),
          offset: Offset(0, 3),
        ),
      ],
    );
  }
}

// Private widget - image section
class _EventImage extends StatelessWidget {
  final String imageUrl;

  const _EventImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppWidthHeight.percentageOfHeight(context, AppDistance.d67),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            AppWidthHeight.percentageOfHeight(context, AppDistance.d10),
          ),
          topRight: Radius.circular(
            AppWidthHeight.percentageOfHeight(context, AppDistance.d10),
          ),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          onError: (error, stackTrace) {
            AssetImage(AppImage.splash);
          },
        ),
      ),
    );
  }
}

// Private widget - details section
class _EventDetails extends StatelessWidget {
  final EventModel event;
  final bool isInterested;
  final VoidCallback onAddInterest;
  final VoidCallback onRemoveInterest;

  const _EventDetails({
    required this.event,
    required this.isInterested,
    required this.onAddInterest,
    required this.onRemoveInterest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppWidthHeight.percentageOfWidth(context, AppDistance.d10),
        vertical: AppWidthHeight.percentageOfHeight(context, AppDistance.d12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event.title,
            style: AppTextStyle.bold14(AppColor.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
              height:
                  AppWidthHeight.percentageOfHeight(context, AppDistance.d8)),
          Row(
            children: [
              Expanded(
                child: Text(
                  event.location,
                  style: AppTextStyle.regular12(AppColor.colorbr80),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InterestedEventButton(
                isInterested: isInterested,
                onAdd: onAddInterest,
                onRemove: onRemoveInterest,
                addText: AppString.join,
                removeText: AppString.joined,
                eventId: event.id!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
