import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';

class EventInfoSection extends StatelessWidget {
  final EventModel event;
  const EventInfoSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title.replaceFirstMapped(
            RegExp(r'^(\S+\s+\S+)'),
            (match) => "${match.group(1)}\n",
          ),
          style: AppTextStyle.bold35(AppColor.colorb26),
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          children: [
            SvgPicture.asset(
              AppIcon.date,
              width: size.width * 0.1230,
              height: size.height * 0.06,
            ),
            SizedBox(width: size.width * 0.03589),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat("dd MMM , yyyy").format(event.date),
                    style: AppTextStyle.semibold16(AppColor.colorb26)),
                Text(
                  "${DateFormat('EEEE').format(event.date)}, ${DateFormat('h:mma').format(event.date)}",
                  style: AppTextStyle.medium12(AppColor.colorbr688),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            SvgPicture.asset(
              AppIcon.location,
              width: size.width * 0.1230,
              height: size.height * 0.06,
            ),
            SizedBox(width: size.width * 0.03589),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.location,
                    style: AppTextStyle.semibold16(AppColor.colorb26)),
                Text(
                  event.location,
                  style: AppTextStyle.medium12(AppColor.colorbr688),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
