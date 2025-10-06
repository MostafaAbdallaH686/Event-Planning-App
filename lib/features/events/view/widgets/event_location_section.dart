import 'package:flutter/material.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';

class EventLocationSection extends StatelessWidget {
  final EventModel event;
  const EventLocationSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.00512),
          child: Text(
            AppString.location,
            style: AppTextStyle.semibold18(AppColor.colorbr688),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.00512),
          child: Container(
            width: double.infinity,
            height: size.height * 0.2425,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              image: const DecorationImage(
                image: AssetImage(AppImage.map),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.0425),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1461538),
          child: CustomTextbutton(
            text: "${AppString.buytecket}  ${event.price} \$",
            onpressed: () {},
          ),
        ),
      ],
    );
  }
}
