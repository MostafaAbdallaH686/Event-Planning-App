import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:event_planning_app/features/booking/data/booking_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final statusColor = booking.status == 'Confirmed'
        ? Colors.green
        : booking.status == 'Pending'
            ? Colors.orange
            : Colors.grey;

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.eventDetails,
          extra: {
            'categoryId': booking.categoryId,
            'eventId': booking.id,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColor.blue.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            // ✅ الصورة
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: booking.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(booking.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: booking.imageUrl.isEmpty
                    ? Colors.grey.shade200
                    : Colors.transparent,
              ),
              child: booking.imageUrl.isEmpty
                  ? const Icon(Icons.image_not_supported)
                  : null,
            ),

            // ✅ المعلومات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الحالة
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      booking.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // العنوان
                  Text(
                    booking.title,
                    style: AppTextStyle.bold16(AppColor.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // الموقع + التاريخ
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          booking.location,
                          style: AppTextStyle.regular12(AppColor.colorbr688),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        booking.date,
                        style: AppTextStyle.regular12(AppColor.colorbr688),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
