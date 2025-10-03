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
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.0256, vertical: size.height * 0.00625),
          child: Column(
            children: [
              const SearchBoxWidget(),
              SizedBox(height: size.height * 0.025),
              const CategoriesSection(),
              SizedBox(height: size.height * 0.025),
              const UpcomingEventsSection(),
              SizedBox(height: size.height * 0.025),
              const PopularEventsSection(),
              SizedBox(height: size.height * 0.025),
              const RecommendedEventsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
