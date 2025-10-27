// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventSummaryModel event;
  final bool isInterested;
  final VoidCallback onAddInterest;
  final VoidCallback onRemoveInterest;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.isInterested,
    required this.onAddInterest,
    required this.onRemoveInterest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: size.width * 0.6,
        margin: EdgeInsets.only(right: size.width * 0.04),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with bookmark button
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: event.imageUrl ?? '',
                    width: double.infinity,
                    height: size.height * 0.15,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.event, size: 50),
                    ),
                  ),
                ),
                // Bookmark button
                Positioned(
                  top: 8,
                  right: 8,
                  child: InkWell(
                    onTap: isInterested ? onRemoveInterest : onAddInterest,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isInterested ? Icons.bookmark : Icons.bookmark_border,
                        size: 20,
                        color: isInterested ? AppColor.border : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTextStyle.bold16(AppColor.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppTextStyle.regular12(AppColor.colorbr688),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
