import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomTextform(
      fillColor: AppColor.colorbr9E,
      prefixicon: AppIcon.search,
      prefixtext: AppString.search,
      suffixicon: Padding(
        padding: EdgeInsets.only(right: size.width * 0.055),
        child: SvgPicture.asset(
          AppIcon.filter,
          height: size.height * 0.03,
          width: size.width * 0.066,
        ),
      ),
    );
  }
}
