import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';
import '../../../../core/utils/utils/app_string.dart';
import '../../data/order_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderModel order;
  final Size size;

  const OrderSummaryCard({super.key, required this.order, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.colorbl83,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppString.orderSummary,
              style: AppTextStyle.bold20(AppColor.colorb26)),
          SizedBox(height: size.height * 0.01875),
          _buildRow(
              title: AppString.tickets, value: "${order.ticketCount} x Ticket"),
          SizedBox(height: size.height * 0.03125),
          _buildRow(
            title: AppString.totalPrice,
            value: "\$${order.totalPrice.toStringAsFixed(2)}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String title,
    required String value,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyle.regular14(AppColor.colorbr88)),
          Text(
            value,
            style: isTotal
                ? AppTextStyle.bold16(AppColor.colorb26)
                : AppTextStyle.semibold14(AppColor.colorb26),
          ),
        ],
      ),
    );
  }
}
