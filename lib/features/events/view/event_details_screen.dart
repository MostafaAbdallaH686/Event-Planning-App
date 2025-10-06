import 'package:event_planning_app/features/events/view/widgets/event_details_screen_body.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen(
      {super.key, required this.categoryId, required this.eventId});
  final String categoryId;
  final String eventId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventDetailsScreenBody(
        categoryId: categoryId,
        eventId: eventId,
      ),
    );
  }
}
