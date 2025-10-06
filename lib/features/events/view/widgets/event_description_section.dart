import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/features/events/view/widgets/expandable_description.dart';
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
        SizedBox(height: size.height * 0.01),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusDirectional.circular(
                  AppWidthHeight.percentageOfWidth(context, 8)),
              child: Image.asset(AppImage.onborading1,
                  width: AppWidthHeight.percentageOfWidth(context, 48),
                  height: AppWidthHeight.percentageOfHeight(context, 48),
                  fit: BoxFit.cover),
            ),
            SizedBox(width: AppWidthHeight.percentageOfWidth(context, 8)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppString.eventArtistName,
                    style: AppTextStyle.bold14(AppColor.colorb26)),
                SizedBox(height: AppWidthHeight.percentageOfWidth(context, 4)),
                Text(AppString.eventArtistRole,
                    style: AppTextStyle.medium12(AppColor.colorbr688)),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.colorbrD8,
                foregroundColor: AppColor.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // Handle follow action
              },
              child: const Text(AppString.eventFollow),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.00512),
          child: ExpandableDescription(
            description: event.description,
            textStyle: AppTextStyle.light16(AppColor.black),
            linkStyle: AppTextStyle.light16(AppColor.blue),
          ),
        ),
      ],
    );
  }
}
