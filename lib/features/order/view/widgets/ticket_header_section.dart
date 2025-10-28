// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TicketHeaderSection extends StatelessWidget {
  final OrderModel order;

  const TicketHeaderSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: size.height * 0.4,
          child: order.imageUrl.isNotEmpty
              ? Image.network(order.imageUrl, fit: BoxFit.cover)
              : Container(
                  color: AppColor.colorblFF.withOpacity(0.1),
                  child: const Center(
                    child: Icon(Icons.image, size: 80, color: Colors.grey),
                  ),
                ),
        ),
        Positioned(
          top: 12,
          left: 20,
          child: InkWell(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          ),
        ),
      ],
    );
  }
}
