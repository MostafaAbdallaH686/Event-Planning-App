import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../../core/utils/utils/app_distance.dart';
import '../../../core/utils/utils/app_icon.dart';
import '../../../core/utils/utils/app_image.dart';
import '../../../core/utils/utils/app_padding.dart';
import '../../../core/utils/utils/app_radius.dart';
import '../../../core/utils/utils/app_routes.dart';
import '../../../core/utils/utils/app_string.dart';

class EventsDetailsScreen extends StatelessWidget {
  const EventsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Event Details"),
            leading: IconButton(
              icon: SvgPicture.asset(
                AppIcon.backArrow,
                width: 24,
                height: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.screen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة الحدث
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.image),
                    child: Image.asset(
                      AppImage.eventDetils,
                      width: double.infinity,
                      height: width * 0.5, // ✅ responsive
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: AppDistance.medium),

                  // عنوان الحدث
                  const Text(
                    AppString.eventTitle,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppDistance.small),

                  // التاريخ
                  const Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18),
                      SizedBox(width: AppDistance.small),
                      Text(AppString.eventDate),
                    ],
                  ),
                  const SizedBox(height: AppDistance.medium),

                  // الوصف
                  const Text(
                    AppString.eventDescription,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: AppDistance.large),

                  // المكان
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      SizedBox(width: AppDistance.small),
                      const Expanded(child: Text(AppString.eventLocation)),
                    ],
                  ),
                  const SizedBox(height: AppDistance.large),

                  // زر الحجز
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.bookingScreen);
                      },
                      child: const Text(AppString.bookNow),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
