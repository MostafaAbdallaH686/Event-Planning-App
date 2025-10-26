import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';
import '../../../../core/utils/utils/app_icon.dart';

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

            // زر العودة للهوم
            SizedBox(
              width: size.width * 0.5,
              height: size.height * 0.00625,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.colorblFF,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  context.pushReplacement(AppRoutes.home);
                },
                child: Text(
                  AppString.goToHome,
                  style: AppTextStyle.bold16(AppColor.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
