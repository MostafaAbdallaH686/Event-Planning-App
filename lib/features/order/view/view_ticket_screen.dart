import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:event_planning_app/features/order/view/widgets/ticket_details_section.dart';
import 'package:event_planning_app/features/order/view/widgets/ticket_header_section.dart';
import 'package:flutter/material.dart';

class ViewTicketScreen extends StatelessWidget {
  final OrderModel order;
  final String seat;
  final String qrImageUrl;

  const ViewTicketScreen({
    super.key,
    required this.order,
    required this.seat,
    required this.qrImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            TicketHeaderSection(order: order),
            TicketDetailsSection(
              order: order,
              seat: seat,
              qrImageUrl: qrImageUrl,
            ),
          ],
        ),
      ),
    );
  }
}
