// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_radius.dart';

class SegmentSelector extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SegmentSelector({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.041,
        horizontal: size.width * 0.09,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.black.withOpacity(.0287),
          borderRadius: AppRadius.segmentsRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: List.generate(segments.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? AppColor.white
                          : Colors.transparent,
                      borderRadius: AppRadius.segmentsRadius,
                      boxShadow: selectedIndex == index
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
                      segments[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: selectedIndex == index
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
    );
  }
}
