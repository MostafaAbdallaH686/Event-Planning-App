import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';
import '../../../../core/utils/utils/app_icon.dart';
import '../../../home/view/home_screen.dart';


class BookingCancelPage extends StatelessWidget {
  const BookingCancelPage({super.key});

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
              width: 82,
              height: 82,
            ),
            const SizedBox(height: 30),

            Text(
              "Your Booking Cancelled Successfully",
              textAlign: TextAlign.center,
              style: AppTextStyle.bold20(AppColor.colorb26),
            ),
            const SizedBox(height: 30),

            // زر العودة للهوم
            SizedBox(
              width: size.width * 0.5,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.colorblFF,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                },
                child: Text(
                  "Go to Home",
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
