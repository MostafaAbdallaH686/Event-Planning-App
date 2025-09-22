import 'package:event_planning_app/features/home/view/widget/category_sections.dart';
import 'package:event_planning_app/features/home/view/widget/popular_events.dart';
import 'package:event_planning_app/features/home/view/widget/recommended_events.dart';
import 'package:event_planning_app/features/home/view/widget/search_box.dart';
import 'package:event_planning_app/features/home/view/widget/upcoming_events.dart';
import 'package:flutter/material.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              // SizedBox(height: size.height * 0.02),
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
