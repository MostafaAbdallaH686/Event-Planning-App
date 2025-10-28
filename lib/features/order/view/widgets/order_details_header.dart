import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';
import '../../data/order_model.dart';

class OrderDetailsHeader extends StatelessWidget {
  final OrderModel order;
  final Size size;

  const OrderDetailsHeader(
      {super.key, required this.order, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: size.height * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(order.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.025),
        Text(
          order.eventName,
          style: AppTextStyle.bold24(AppColor.colorb26),
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          children: [
            const Icon(Icons.calendar_today,
                color: AppColor.colorgr88, size: 18),
            SizedBox(width: size.width * 0.01538),
            Text(order.eventDate,
                style: AppTextStyle.regular14(AppColor.colorbr88)),
            SizedBox(width: size.width * 0.04102),
            const Icon(Icons.access_time, color: AppColor.colorgr88, size: 18),
            SizedBox(width: size.width * 0.01538),
            Text(order.eventTime,
                style: AppTextStyle.regular14(AppColor.colorbr88)),
          ],
        ),
        SizedBox(height: size.height * 0.01875),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, color: AppColor.colorgr88, size: 18),
            SizedBox(width: size.width * 0.01538),
            Expanded(
              child: Text(order.location,
                  style: AppTextStyle.regular14(AppColor.colorbr88)),
            ),
          ],
        ),
      ],
    );
  }
}
