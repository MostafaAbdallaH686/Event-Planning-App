//ToDo  Later :: Mostafa :: static for now until we decide what to do

// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:flutter/material.dart';

class BookingScreenBody extends StatefulWidget {
  const BookingScreenBody({super.key});

  @override
  State<BookingScreenBody> createState() => _BookingScreenBodyState();
}

class _BookingScreenBodyState extends State<BookingScreenBody> {
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': '1',
      'title': 'Tech Conference 2024',
      'location': 'Downtown Convention Center',
      'date': 'Jun 15, 2024',
      'status': 'Confirmed',
      'imageUrl': AppImage.emptyEvent,
    },
    {
      'id': '2',
      'title': 'Music Festival',
      'location': 'Central Park',
      'date': 'Jul 22, 2024',
      'status': 'Pending',
      'imageUrl': AppImage.auth,
    },
    {
      'id': '3',
      'title': 'Workshop: Flutter Advanced',
      'location': 'Innovation Hub',
      'date': 'Aug 5, 2024',
      'status': 'Confirmed',
      'imageUrl': AppImage.map,
    },
  ];

  Future<void> _showDeleteConfirmation(
      BuildContext context, String id, String title) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Booking'),
          content: Text('Are you sure you want to delete "$title"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _bookings.removeWhere((booking) => booking['id'] == id);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          return Dismissible(
            key: Key(booking['id']),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              setState(() {
                _bookings.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${booking['title']} deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _bookings.insert(index, booking);
                      });
                    },
                  ),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            child: _buildTicketCard(context, booking),
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, Map<String, dynamic> booking) {
    final statusColor = booking['status'] == 'Confirmed'
        ? Colors.green
        : booking['status'] == 'Pending'
            ? Colors.orange
            : Colors.grey;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColor.blue.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          // Event Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              booking['imageUrl'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      booking['status'],
                      style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Event title
                  Text(
                    booking['title'],
                    style: AppTextStyle.bold16(AppColor.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Location & Date
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          booking['location'],
                          style: AppTextStyle.regular12(AppColor.colorbr688),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        booking['date'],
                        style: AppTextStyle.regular12(AppColor.colorbr688),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _showDeleteConfirmation(
                          context,
                          booking['id'],
                          booking['title'],
                        ),
                        icon: const Icon(Icons.delete,
                            size: 18, color: Colors.red),
                        label: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
