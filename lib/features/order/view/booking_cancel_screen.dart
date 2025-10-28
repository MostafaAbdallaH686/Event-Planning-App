import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class BookingCancelScreen extends StatelessWidget {
  const BookingCancelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcon.greentrue,
              width: size.width * 0.21,
              height: size.height * 0.1025,
            ),
            SizedBox(height: size.height * 0.0375),
            Text(
              AppString.bookingCancelledSuccessfully,
              textAlign: TextAlign.center,
              style: AppTextStyle.bold20(AppColor.colorb26),
            ),
            SizedBox(height: size.height * 0.0375),
            CustomTextbutton(
                text: AppString.goToHome,
                onpressed: () {
                  context.pushReplacement(AppRoutes.home);
                }),
          ],
        ),
      ),
    );
  }
}
