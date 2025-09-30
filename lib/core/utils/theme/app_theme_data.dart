import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/utils/app_distance.dart';
import '../../../core/utils/utils/app_icon.dart';
import '../../../core/utils/utils/app_image.dart';
import '../../../core/utils/utils/app_padding.dart';


class EventsDetailsScreen extends StatelessWidget {
  const EventsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmall = screenWidth < 360;

    final double titleSize = isSmall ? 28 : 35;
    final double subTitleSize = isSmall ? 12 : 14;
    final double bodySize = isSmall ? 14 : 16;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final headerHeight = constraints.maxWidth * 0.55;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: headerHeight,
                    child: Image.asset(
                      AppImage.eventDetils,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          AppIcon.backArrow,
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black38,
                      child: IconButton(
                        icon: const Icon(Icons.bookmark_border, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    top: headerHeight - 36,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [

                            ],
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "+20 Going",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("Invite"),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDistance.large + 12),

              Padding(
                padding: AppPadding.horizontal16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Darshan Raval\nMusic Show",
                      style: TextStyle(
                        fontSize: titleSize,
                        height: 0.95,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF120D26),
                      ),
                    ),

                    const SizedBox(height: AppDistance.medium),

                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5669FF).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: SvgPicture.asset(AppIcon.calendar, width: 20, height: 20),
                          ),
                        ),
                        const SizedBox(width: AppDistance.medium),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("03 May , 2023", style: TextStyle(fontWeight: FontWeight.w700, fontSize: subTitleSize + 2)),
                            const SizedBox(height: 4),
                            Text("Tuesday, 4:00PM - 9:00PM", style: TextStyle(fontSize: subTitleSize, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDistance.medium),

                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF5669FF).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(child: SvgPicture.asset(AppIcon.location, width: 20, height: 20)),
                        ),
                        const SizedBox(width: AppDistance.medium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("karnavati club", style: TextStyle(fontWeight: FontWeight.w700, fontSize: subTitleSize + 2)),
                              const SizedBox(height: 4),
                              Text("36 Rings Street New Ranip , Ahmedabad", style: TextStyle(fontSize: subTitleSize, color: Colors.grey[600])),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDistance.large),

                    Text("About Event", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    const SizedBox(height: AppDistance.small),

                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),

                        ),
                        const SizedBox(width: AppDistance.small),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Darshan Raval", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text("Singer", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {},
                          child: const Text("Follow"),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDistance.medium),

                    Text(
                      "Enjoy your favorite show and a lovely your friends and family and have a great time. "
                          "Food from local food trucks will be available for purchase. Read More...",
                      style: TextStyle(color: Colors.grey[600], fontSize: bodySize, height: 1.5),
                    ),

                    const SizedBox(height: AppDistance.large),

                    Text("Location", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    const SizedBox(height: AppDistance.small),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(AppImage.map, width: double.infinity, height: 180, fit: BoxFit.cover),
                    ),

                    const SizedBox(height: AppDistance.large + 10),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0055FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 12,
                          shadowColor: const Color(0x6F7EC9FF),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Buy Ticket", style: TextStyle(fontSize: bodySize, color: Colors.white)),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text("\$150", style: TextStyle(fontSize: bodySize, fontWeight: FontWeight.bold, color: Colors.white)),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 14,
                                    child: const Icon(Icons.arrow_forward, color: Colors.black, size: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
