// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:flutter/material.dart';

class TicketDetailsSection extends StatelessWidget {
  final OrderModel order;
  final String seat;
  final String qrImageUrl;

  const TicketDetailsSection({
    super.key,
    required this.order,
    required this.seat,
    required this.qrImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
      top: 157,
      left: 20,
      right: 20,
      bottom: 20,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.0512,
          vertical: size.height * 0.0225,
        ),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: AppColor.colorbl83,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppString.viewTicket,
                style: AppTextStyle.bold24(AppColor.colorb26)),
            SizedBox(height: size.height * 0.01875),

            /// 🔹 QR Image
            Container(
              width: size.width * 0.4615,
              height: size.width * 0.225,
              decoration: BoxDecoration(
                color: AppColor.colorblFF.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColor.colorblFF.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: qrImageUrl.isNotEmpty
                  ? Image.network(qrImageUrl)
                  : const Icon(Icons.qr_code_2,
                      color: AppColor.colorblFF, size: 60),
            ),
            SizedBox(height: size.height * 0.03125),

            Text(order.eventName,
                style: AppTextStyle.bold21(AppColor.colorb26),
                textAlign: TextAlign.center),
            SizedBox(height: size.height * 0.01),

            Text(order.location,
                style: AppTextStyle.regular16(AppColor.colorbr88),
                textAlign: TextAlign.center),
            SizedBox(height: size.height * 0.025),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppString.date,
                        style: AppTextStyle.regular14(AppColor.colorbr88)),
                    Text(order.eventDate,
                        style: AppTextStyle.semibold15(AppColor.colorb26)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(AppString.time,
                        style: AppTextStyle.regular14(AppColor.colorbr88)),
                    Text(order.eventTime,
                        style: AppTextStyle.semibold15(AppColor.colorb26)),
                  ],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01875),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppString.seat,
                    style: AppTextStyle.regular14(AppColor.colorbr88)),
                Text(seat, style: AppTextStyle.semibold15(AppColor.colorb26)),
              ],
            ),
            const Spacer(),

            CustomTextbutton(
              text: AppString.rateUs,
              onpressed: () {
                // بعدين هتضيف هنا navigation للـ ReviewPage
              },
            ),
          ],
        ),
      ),
    );
  }
}
