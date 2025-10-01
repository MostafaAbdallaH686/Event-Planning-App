import 'package:flutter/material.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';

class EventDescriptionSection extends StatelessWidget {
  final EventModel event;
  const EventDescriptionSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.00512),
          child: Text(
            AppString.aboutEvent,
            style: AppTextStyle.semibold18(AppColor.colorbr688),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.00512),
          child: Text(
            event.description,
            style: AppTextStyle.light16(AppColor.black),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
