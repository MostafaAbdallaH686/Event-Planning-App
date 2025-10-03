import 'package:event_planning_app/core/utils/function/app_svg_image.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/booking/view/booking_screen.dart';
import 'package:event_planning_app/features/home/view/home_screen.dart';
import 'package:event_planning_app/features/home/view/see_all_upcoming_screen.dart';
import 'package:event_planning_app/features/home/view/widgets/recommended_events.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  final int index;
  const MainNavigation({super.key, this.index = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  final List<Widget> _screens = [
    HomeScreen(),
    RecommendedEventsSection(),
    BookingScreen(),
    SeeAllUpComingScreen()
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.white,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.white,
        currentIndex: _currentIndex,
        selectedItemColor: AppColor.blue,
        unselectedItemColor: AppColor.colorbr688,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          _buildNavItem(
            iconPath: AppIcon.home,
            label: AppString.homeNav,
            isSelected: _currentIndex == 0,
          ),
          _buildNavItem(
            iconPath: AppIcon.events,
            label: AppString.eventsNav,
            isSelected: _currentIndex == 1,
          ),
          _buildNavItem(
            iconPath: AppIcon.orders,
            label: AppString.ordersNav,
            isSelected: _currentIndex == 2,
          ),
          _buildNavItem(
            iconPath: AppIcon.profile,
            label: AppString.profileNav,
            isSelected: _currentIndex == 3,
          ),
        ],
      ),
    );
  }
}

BottomNavigationBarItem _buildNavItem({
  required String iconPath,
  required String label,
  required bool isSelected,
}) {
  final color = isSelected ? AppColor.blue : AppColor.colorbr688;
  return BottomNavigationBarItem(
    icon: AppSvgImage.showSvgImage(path: iconPath, color: color),
    label: label,
  );
}
