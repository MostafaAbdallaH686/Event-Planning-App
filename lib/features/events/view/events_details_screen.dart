import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/utils/utils/app_distance.dart';
import '../../../core/utils/utils/app_icon.dart';
import '../../../core/utils/utils/app_image.dart';
import '../../../core/utils/utils/app_padding.dart';
import '../../../core/utils/theme/app_colors.dart';
import '../../../core/utils/utils/app_string.dart';
import '../../../core/utils/utils/app_radius.dart';


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
                    top: AppHeight.h40,
                    left: AppDistance.medium,
                    child: CircleAvatar(
                      backgroundColor: AppColor.black.withOpacity(0.38),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          AppIcon.backArrow,
                          width: AppWidth.w20,
                          height: AppHeight.h20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppHeight.h40,
                    right: AppDistance.medium,
                    child: CircleAvatar(
                      backgroundColor: AppColor.black.withOpacity(0.38),
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline, color: AppColor.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    left: AppDistance.medium + 4,
                    right: AppDistance.medium + 4,
                    top: headerHeight - AppHeight.h36,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: AppDistance.medium - 2, vertical: AppHeight.h10),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: AppRadius.profileChipRadius,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black.withOpacity(0.12),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(radius: AppWidth.w28 / 2, backgroundImage: AssetImage(AppImage.user3)),
                              Positioned(
                                left: AppWidth.w14,
                                child: CircleAvatar(radius: AppWidth.w28 / 2, backgroundImage: AssetImage(AppImage.user2)),
                              ),
                              Positioned(
                                left: AppWidth.w28,
                                child: CircleAvatar(radius: AppWidth.w28 / 2, backgroundImage: AssetImage(AppImage.user1)),
                              ),
                            ],
                          ),
                          const SizedBox(width: AppDistance.medium - 4),
                          const Text(
                            AppString.eventGoing,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.colorbrD8,
                              foregroundColor: AppColor.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.small,
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(AppString.eventInvite),
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
                      AppString.eventSpecificTitle,
                      style: TextStyle(
                        fontSize: titleSize,
                        height: 0.95,
                        fontWeight: FontWeight.w800,
                        color: AppColor.colorb26,
                      ),
                    ),

                    const SizedBox(height: AppDistance.medium),

                    Row(
                      children: [
                        Container(
                          width: AppWidth.w48,
                          height: AppHeight.h48,
                          decoration: BoxDecoration(
                            color: AppColor.colorblFF.withOpacity(0.12),
                            borderRadius: AppRadius.small,
                          ),
                          child: Center(
                            child: SvgPicture.asset(AppIcon.calendar, width: AppWidth.w20, height: AppHeight.h20),
                          ),
                        ),
                        const SizedBox(width: AppDistance.medium),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppString.eventDateSpecific, style: TextStyle(fontWeight: FontWeight.w700, fontSize: subTitleSize + 2)),
                            const SizedBox(height: 4),
                            Text(AppString.eventTimeSpecific, style: TextStyle(fontSize: subTitleSize, color: AppColor.colorbr688)),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDistance.medium),

                    Row(
                      children: [
                        Container(
                          width: AppWidth.w48,
                          height: AppHeight.h48,
                          decoration: BoxDecoration(
                            color: AppColor.colorblFF.withOpacity(0.12),
                            borderRadius: AppRadius.small,
                          ),
                          child: Center(child: SvgPicture.asset(AppIcon.location, width: AppWidth.w20, height: AppHeight.h20)),
                        ),
                        const SizedBox(width: AppDistance.medium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppString.eventLocationName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: subTitleSize + 2)),
                              const SizedBox(height: 4),
                              Text(AppString.eventLocationAddress, style: TextStyle(fontSize: subTitleSize, color: AppColor.colorbr688)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDistance.large),

                    Text(AppString.aboutEvent, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    const SizedBox(height: AppDistance.small),

                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.small,
                          child: Image.asset(AppImage.singer, width: AppWidth.w48, height: AppHeight.h48, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: AppDistance.small),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppString.eventArtistName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(AppString.eventArtistRole, style: TextStyle(color: AppColor.colorbr688, fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.colorbrD8,
                            foregroundColor: AppColor.black,
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
                          ),
                          onPressed: () {},
                          child: const Text(AppString.eventFollow),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDistance.medium),

                    Text.rich(
                      TextSpan(
                        text: "Enjoy your favorite show and a lovely your friends and family and have a great time. Food from local food trucks will be available for purchase. ",
                        style: TextStyle(color: AppColor.colorbr688, fontSize: bodySize, height: 1.5),
                        children: const [
                          TextSpan(
                            text: AppString.readMore,
                            style: TextStyle(
                              color: AppColor.colorb4D,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDistance.large),

                    Text(AppString.location, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    const SizedBox(height: AppDistance.small),

                    ClipRRect(
                      borderRadius: AppRadius.buttonRaduis,
                      child: Image.asset(AppImage.map, width: double.infinity, height: AppHeight.h180, fit: BoxFit.cover),
                    ),

                    const SizedBox(height: AppDistance.large + 10),

                    SizedBox(
                      width: double.infinity,
                      height: AppHeight.h56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryButton,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRaduis),
                          elevation: 12,
                          shadowColor: AppColor.primaryButton.withOpacity(0.43),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppString.buyTicket, style: TextStyle(fontSize: bodySize, color: AppColor.white)),
                            const SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: AppDistance.small, vertical: AppHeight.h6),
                              decoration: BoxDecoration(
                                color: AppColor.white.withOpacity(0.16),
                                borderRadius: AppRadius.small,
                              ),
                              child: Row(
                                children: [
                                  Text("\$150", style: TextStyle(fontSize: bodySize, fontWeight: FontWeight.bold, color: AppColor.white)),
                                  const SizedBox(width: AppDistance.small),
                                  CircleAvatar(
                                    backgroundColor: AppColor.white,
                                    radius: 14,
                                    child: const Icon(Icons.arrow_forward, color: AppColor.black, size: 16),
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