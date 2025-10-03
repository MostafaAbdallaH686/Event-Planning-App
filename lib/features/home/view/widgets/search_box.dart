import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widget/custom_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = TextEditingController();

    return CustomTextform(
      controller: controller,
      fillColor: AppColor.colorbr9E,
      prefixicon: AppIcon.search,
      prefixtext: AppString.search,
      suffixicon: InkWell(
        onTap: () {
          if (controller.text.isNotEmpty) {
            context.push(AppRoutes.searchScreen, extra: controller.text);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(right: size.width * 0.06),
          child: SvgPicture.asset(
            AppIcon.filter,
            height: size.height * 0.03,
            width: size.width * 0.066,
          ),
        ),
      ),
      onFieldSubmitted: (value) {
        if (value.isNotEmpty) {
          context.push('/SearchScreen', extra: value);
        }
      },
    );
  }
}
