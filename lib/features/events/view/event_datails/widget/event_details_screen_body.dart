import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/features/events/cubit/event_details_cubit.dart';
import 'package:event_planning_app/features/events/cubit/event_details_state.dart';
import 'package:event_planning_app/features/events/view/event_datails/widget/event_description_section.dart';
import 'package:event_planning_app/features/events/view/event_datails/widget/event_header_section.dart';
import 'package:event_planning_app/features/events/view/event_datails/widget/event_info_section.dart';
import 'package:event_planning_app/features/events/view/event_datails/widget/event_location_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsScreenBody extends StatelessWidget {
  const EventDetailsScreenBody(
      {super.key, required this.categoryId, required this.eventId});
  final String categoryId;
  final String eventId;

  @override
  Widget build(BuildContext context) {
    context.read<EventCubit>().getEventById(categoryId, eventId);
    return Scaffold(
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventLoaded) {
            final event = state.event;
            return _buildEventDetails(context, event);
          } else if (state is EventError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context, EventModel event) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventHeaderSection(event: event),
          SizedBox(height: size.height * 0.03),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.051282),
            child: EventInfoSection(event: event),
          ),
          SizedBox(height: size.height * 0.02875),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.0435),
            child: EventDescriptionSection(event: event),
          ),
          SizedBox(height: size.height * 0.02),
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.0435),
            child: EventLocationSection(event: event),
          ),
          SizedBox(height: size.height * 0.01),
        ],
      ),
    );
  }
}
