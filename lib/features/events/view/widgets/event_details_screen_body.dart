import 'package:event_planning_app/features/events/data/models/event_model.dart';
import 'package:event_planning_app/features/events/view/widgets/event_description_section.dart';
import 'package:event_planning_app/features/events/view/widgets/event_header_section.dart';
import 'package:event_planning_app/features/events/view/widgets/event_info_section.dart';
import 'package:event_planning_app/features/events/view/widgets/event_location_section.dart';
import 'package:flutter/material.dart';

class EventDetailsScreenBody extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreenBody({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0.0;
        if (velocity > 300) {
          Navigator.maybePop(context);
        }
      },
      child: CustomScrollView(
        slivers: [
          // Event Header (Image + Back button)
          SliverToBoxAdapter(
            child: EventHeaderSection(event: event),
          ),

          // Event Content
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.051282,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: size.height * 0.03),

                // Event Info (Title, Date, Location)
                EventInfoSection(event: event),
                SizedBox(height: size.height * 0.02875),

                // Event Description (About & Organizer)
                EventDescriptionSection(event: event),
                SizedBox(height: size.height * 0.02),

                // Event Location (Map & Buy button)
                EventLocationSection(event: event),
                SizedBox(height: size.height * 0.02),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
