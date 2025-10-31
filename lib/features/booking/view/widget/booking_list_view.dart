import 'package:flutter/material.dart';
import 'package:event_planning_app/features/booking/data/booking_model.dart';
import 'booking_card.dart';

class BookingListView extends StatelessWidget {
  final List<BookingModel> bookings;

  const BookingListView({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(booking: bookings[index]);
      },
    );
  }
}
