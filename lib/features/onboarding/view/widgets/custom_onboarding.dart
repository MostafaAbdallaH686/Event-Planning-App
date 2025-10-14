import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomOnboarding extends StatelessWidget {
  final String imagePath;
  final String title;
  final int index;
  final String buttonText;
  final VoidCallback onPressed;
  const CustomOnboarding({
    super.key,
    required this.index,
    required this.imagePath,
    required this.title,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          /// الخلفية (الصورة)
          Image.asset(
            imagePath,
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),

          Positioned(
            bottom: size.height * 0.08,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bold24(AppColor.white),
                ),
                const SizedBox(height: 10),
                Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: index,
                    curve: Curves.bounceOut,
                    count: 3,
                    onEnd: () {
                      context.pushReplacement('/register');
                    },
                    effect: ExpandingDotsEffect(
                      dotHeight: size.height * 0.01,
                      dotWidth: size.width * 0.03,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue,
                    ),
                    duration: Duration(milliseconds: 500),
                    axisDirection: Axis.horizontal,
                    onDotClicked: (index) {
                      if (index != 0) {
                        index -= 1;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextbutton(
                  text: buttonText,
                  onpressed: onPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
