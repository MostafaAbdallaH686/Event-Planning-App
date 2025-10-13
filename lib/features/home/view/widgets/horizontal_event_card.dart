// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/view/widgets/interested_event_button.dart';
import 'package:flutter/material.dart';

class HorizontalEventCard extends StatelessWidget {
  final EventModel event;
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
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.0205),
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.008,
          horizontal: size.width * 0.0256,
        ),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: size.width * 0.25,
              height: size.height * 0.09,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {},
                ),
              ),
            ),
            SizedBox(width: size.width * 0.0205),
            SizedBox(
              width: size.width * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.title,
                    style: AppTextStyle.bold16(AppColor.colorbA1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.005),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppTextStyle.regular12(AppColor.colorbr688),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InterestedEventButton(
                        isInterested: isInterested,
                        onAdd: onAddInterest,
                        onRemove: onRemoveInterest,
                        addText: AppString.join,
                        removeText: AppString.joined,
                        size: Size(size.width * 0.2051, size.height * 0.0375),
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
