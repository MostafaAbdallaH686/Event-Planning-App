import 'package:event_planning_app/core/utils/services/payment_test.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:event_planning_app/features/order/view/widgets/order_details_header.dart';
import 'package:event_planning_app/features/order/view/widgets/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppString.orderDetails,
          style: AppTextStyle.bold20(AppColor.colorb26),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.0512,
          vertical: size.height * 0.01875,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderDetailsHeader(order: order, size: size),
            SizedBox(height: size.height * 0.03125),
            OrderSummaryCard(order: order, size: size),
            SizedBox(height: size.height * 0.0375),
            CustomTextbutton(
              text: AppString.placeOrder,
              onpressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => StripePaymentDialog(
                    onPaymentSuccess: () {
                      context.pushReplacement(
                        AppRoutes.ticketBooked,
                        extra: {
                          'order': order.copyWith(
                            paymentMethod: AppString.creditDebitCard,
                          ),
                          'seat': 'A12',
                          'qrImageUrl': '',
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
