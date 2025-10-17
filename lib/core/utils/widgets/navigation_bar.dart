import 'package:event_planning_app/core/utils/function/app_svg_image.dart';
import 'package:event_planning_app/core/utils/function/app_width_height.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/booking/view/booking_screen.dart';
import 'package:event_planning_app/features/events/view/empty_event_screen.dart';
import 'package:event_planning_app/features/home/view/home_screen.dart';
import 'package:event_planning_app/features/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    EmptyEventScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.white,
      ),
      body: _screens[_currentIndex],

      // Center FAB
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: AppWidthHeight.percentageOfHeight(context, 50),
        width: AppWidthHeight.percentageOfWidth(context, 50),
        decoration: BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: 'main_fab',
          backgroundColor: AppColor.colorgr88,
          onPressed: () {
            context.push(AppRoutes.createEvent);
          },
          child: Icon(Icons.add,
              size: AppWidthHeight.percentageOfWidth(context, 32),
              color: AppColor.white),
        ),
      ),

      // Bottom bar with notch
      bottomNavigationBar: BottomAppBar(
        color: AppColor.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 8,
        child: SizedBox(
          height: AppWidthHeight.percentageOfHeight(context, 64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left side: two tabs
              _TabItem(
                iconPath: AppIcon.home,
                label: AppString.homeNav,
                selected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _TabItem(
                iconPath: AppIcon.events,
                label: AppString.eventsNav,
                selected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),

              // Space for FAB notch
              const SizedBox(width: 48),

              // Right side: two tabs
              _TabItem(
                iconPath: AppIcon.orders,
                label: AppString.ordersNav,
                selected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
              _TabItem(
                iconPath: AppIcon.profile,
                label: AppString.profileNav,
                selected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.iconPath,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColor.blue : AppColor.colorbr688;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: AppWidthHeight.percentageOfWidth(context, 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgImage.showSvgImage(path: iconPath, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: color)),
          ],
        ),
      ),
    );
  }
}
