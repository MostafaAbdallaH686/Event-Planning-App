import 'package:event_planning_app/features/home/view/widgets/category_sections.dart';
import 'package:event_planning_app/features/home/view/widgets/popular_events.dart';
import 'package:event_planning_app/features/home/view/widgets/recommended_events.dart';
import 'package:event_planning_app/features/home/view/widgets/search_box.dart';
import 'package:event_planning_app/features/home/view/widgets/upcoming_events.dart';
import 'package:flutter/material.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.0256,
            vertical: size.height * 0.00625,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchBoxWidget(),
              SizedBox(height: size.height * 0.025),

              // Categories
              const CategoriesSection(),
              SizedBox(height: size.height * 0.025),

              // Upcoming Events
              const UpcomingEventsSection(),
              SizedBox(height: size.height * 0.025),

              // Popular Events
              const PopularEventsSection(),
              SizedBox(height: size.height * 0.025),

              // Recommended Events
              const RecommendedEventsSection(),
              SizedBox(height: size.height * 0.025),
            ],
          ),
        ),
      ),
    );
  }
}
