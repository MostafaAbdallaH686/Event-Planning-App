import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/features/events/view/widgets/event_share_bottom.dart';
import 'package:flutter/material.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventHeaderSection extends StatelessWidget {
  final EventModel event;
  const EventHeaderSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.3625,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: size.height * 0.345,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              image: DecorationImage(
                image: NetworkImage(event.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 5,
            child: CircleAvatar(
              backgroundColor: AppColor.black.withOpacity(0.38),
              child: IconButton(
                icon: const Icon(Icons.chat_bubble_outline,
                    color: AppColor.white),
                onPressed: () {
                  //handle chat button press
                },
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.053,
            left: size.width * 0.0256410,
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    AppIcon.backArrow,
                    color: AppColor.white,
                  ),
                ),
                SizedBox(width: size.width * 0.2564),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.312,
            left: size.width * 0.13,
            child: Container(
              width: size.width * 0.756410,
              height: size.width * 0.1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                color: AppColor.white,
              ),
              child: Row(
                children: [
                  SizedBox(width: AppWidthHeight.percentageOfWidth(context, 5)),

                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      CircleAvatar(
                          radius: AppWidthHeight.percentageOfWidth(context, 14),
                          backgroundColor: AppColor.white,
                          backgroundImage: AssetImage(AppImage.onborading1)),
                      Positioned(
                        left: AppWidthHeight.percentageOfWidth(context, 20),
                        child: CircleAvatar(
                            radius:
                                AppWidthHeight.percentageOfWidth(context, 14),
                            backgroundColor: AppColor.white,
                            backgroundImage: AssetImage(AppImage.onborading2)),
                      ),
                      Positioned(
                        left: AppWidthHeight.percentageOfWidth(context, 30),
                        child: CircleAvatar(
                            radius:
                                AppWidthHeight.percentageOfWidth(context, 14),
                            backgroundColor: AppColor.white,
                            backgroundImage: AssetImage(AppImage.onborading3)),
                      ),
                      SizedBox(
                          width: AppWidthHeight.percentageOfWidth(context, 60)),
                    ],
                  ),
                  // SizedBox(width: size.width * 0.156),
                  Text(
                    "+${event.attendeesCount} ${AppString.going}",
                    style: AppTextStyle.regular15(AppColor.black),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: BorderRadius.all(Radius.circular(24))
                                  .topLeft),
                        ),
                        builder: (BuildContext context) {
                          return const EventShareBottomSheet();
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: AppWidthHeight.percentageOfWidth(context, 8)),
                      child: Container(
                        width: size.width * 0.17179,
                        height: size.height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: AppColor.colorbr80,
                        ),
                        child: Center(
                          child: Text(
                            AppString.invite,
                            style: AppTextStyle.regular12(AppColor.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
