// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_radius.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:flutter/material.dart';

class EmptyEventScreenBody extends StatefulWidget {
  const EmptyEventScreenBody({super.key});

  @override
  State<EmptyEventScreenBody> createState() => _EmptyEventScreenBodyState();
}

class _EmptyEventScreenBodyState extends State<EmptyEventScreenBody> {
  int _selectedSegment = 0;
  final List<String> _segments = [AppString.upcoming, AppString.pastEvents];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.height * 0.041, horizontal: size.width * 0.09),
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.black.withOpacity(.0287),
              borderRadius: AppRadius.segmentsRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: List.generate(_segments.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSegment = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedSegment == index
                              ? AppColor.white
                              : Colors.transparent,
                          borderRadius: AppRadius.segmentsRadius,
                          boxShadow: _selectedSegment == index
                              ? [
                                  BoxShadow(
                                    color: AppColor.black.withOpacity(0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  )
                                ]
                              : null,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.014),
                        child: Text(
                          _segments[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: _selectedSegment == index
                                ? AppColor.black
                                : AppColor.colorbr9B,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        // Content area
        Image.asset(
          AppImage.emptyEvent,
          width: size.width * 0.8125,
          height: size.height * 0.25,
        ),
        Text(
          AppString.noUpcomingEvents,
          style: AppTextStyle.semibold24(AppColor.colorb26),
        ),
        SizedBox(height: size.height * 0.012),
        Text(
          AppString.noResult,
          style: AppTextStyle.regular16(AppColor.colorbr688),
        ),
        SizedBox(height: size.height * 0.024),
        const Spacer(),
        CustomTextbutton(
          text: AppString.exploreEvent,
          onpressed: () {},
          isIconAdded: true,
        ),
        SizedBox(height: size.height * 0.06),
      ],
    );
  }
}
