import 'package:event_planning_app/features/events/data/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';

class EventLocationSection extends StatelessWidget {
  final EventModel event;

  const EventLocationSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location title
        Text(
          AppString.location,
          style: AppTextStyle.semibold18(AppColor.colorbr688),
        ),
        SizedBox(height: size.height * 0.015),

        // Location address
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColor.border),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  event.location,
                  style: AppTextStyle.medium14(AppColor.black),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.directions),
                onPressed: () {
                  // TODO: Open maps with location
                },
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.02),

        // Map placeholder (or integrate Google Maps)
        Container(
          width: double.infinity,
          height: size.height * 0.2425,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[300],
          ),
          child: const Center(
            child: Icon(Icons.map, size: 50, color: Colors.grey),
          ),
        ),
        SizedBox(height: size.height * 0.03),

        // Buy/Register button
        Center(
          child: SizedBox(
            width: size.width * 0.7,
            child: CustomTextbutton(
              text: event.isFull
                  ? 'Event Full'
                  : event.isFree
                      ? 'Register for Free'
                      : 'Buy Ticket • ${event.displayPrice}',
              onpressed: event.isFull
                  ? () {} // Provide an empty function if the event is full
                  : () {
                      // TODO: Handle registration/payment
                      _showRegistrationDialog(context, event);
                    },
            ),
          ),
        ),
      ],
    );
  }

  void _showRegistrationDialog(BuildContext context, EventModel event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register for Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title),
            const SizedBox(height: 8),
            Text('Price: ${event.displayPrice}'),
            const SizedBox(height: 8),
            Text('Available spots: ${event.availableSpots}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement registration
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
