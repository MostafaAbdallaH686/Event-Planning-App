import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/payment_info_card.dart';
import 'widgets/action_buttons_section.dart';

class TicketBookedScreen extends StatelessWidget {
  final OrderModel order;
  final String seat;
  final String qrImageUrl;

  const TicketBookedScreen({
    super.key,
    required this.order,
    required this.seat,
    required this.qrImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.0512,
            vertical: size.height * 0.03125,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcon.greentrue,
                width: size.width * 0.3,
                height: size.width * 0.3,
              ),
              SizedBox(height: size.height * 0.03125),
              Text(
                AppString.congratulations,
                style: AppTextStyle.bold24(AppColor.colorb26),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                "${AppString.yourTicketfor}\"${order.eventName}\" ${AppString.bookingSuccess}",
                textAlign: TextAlign.center,
                style: AppTextStyle.regular15(AppColor.colorbr88),
              ),
              SizedBox(height: size.height * 0.0375),
              PaymentInfoCard(
                paymentMethod: order.paymentMethod,
                totalPrice: order.totalPrice,
              ),
              SizedBox(height: size.height * 0.0625),
              ActionButtonsSection(
                order: order,
                seat: seat,
                qrImageUrl: qrImageUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
