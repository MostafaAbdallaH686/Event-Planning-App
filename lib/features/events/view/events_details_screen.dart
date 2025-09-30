import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/utils/app_icon.dart';
import '../../../core/utils/utils/app_image.dart';



class EventsDetailsScreen extends StatelessWidget {
  const EventsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppImage.eventDetils,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Tech Conference 2025",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),


              Row(
                children: [
                  SvgPicture.asset(
                    AppIcon.calendar,
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text("30 September 2025"),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                "Join us for an exciting tech conference where industry leaders "
                    "will share insights on AI, Flutter, and the future of technology.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),

              // المكان
              Row(
                children: [
                  SvgPicture.asset(
                    AppIcon.location,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text("Cairo International Convention Center"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                   /// Navigator.pushNamed(context, AppRoutes.bookingScreen);
                  },
                  child: const Text("Book Now"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
