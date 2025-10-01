import 'package:flutter/material.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';

class EventHeaderSection extends StatelessWidget {
  final EventModel event;
  const EventHeaderSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.3425,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: size.height * 0.305,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(event.imageUrl),
                fit: BoxFit.cover,
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
                  child: const Icon(Icons.arrow_back, color: AppColor.white),
                ),
                SizedBox(width: size.width * 0.2564),
                Text(
                  AppString.eventDetails,
                  style: AppTextStyle.bold22(AppColor.white),
                ),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.285,
            left: size.width * 0.092,
            child: Container(
              width: size.width * 0.756410,
              height: size.width * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColor.white,
              ),
              child: Row(
                children: [
                  SizedBox(width: size.width * 0.256),
                  Text(
                    "+${event.attendeesCount} ${AppString.going}",
                    style: AppTextStyle.regular15(AppColor.black),
                  ),
                  SizedBox(width: size.width * 0.0692),
                  Container(
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
