import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:event_planning_app/features/order/view/ticket_booked_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';

import '../../../../core/utils/utils/app_icon.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String _selectedPaymentMethod = AppString.creditDebitCard;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final order = widget.order;

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
        iconTheme: const IconThemeData(color: AppColor.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ----------- EVENT IMAGE -----------
            Container(
              width: double.infinity,
              height: size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(order.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// ----------- EVENT TITLE -----------
            Text(
              order.eventName,
              style: AppTextStyle.bold24(AppColor.colorb26),
            ),
            const SizedBox(height: 8),

            /// ----------- DATE & TIME -----------
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: AppColor.colorgr88, size: 18),
                const SizedBox(width: 6),
                Text(order.eventDate,
                    style: AppTextStyle.regular14(AppColor.colorbr88)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time,
                    color: AppColor.colorgr88, size: 18),
                const SizedBox(width: 6),
                Text(order.eventTime,
                    style: AppTextStyle.regular14(AppColor.colorbr88)),
              ],
            ),
            const SizedBox(height: 15),

            /// ----------- LOCATION -----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on,
                    color: AppColor.colorgr88, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(order.location,
                      style: AppTextStyle.regular14(AppColor.colorbr88)),
                ),
              ],
            ),
            const SizedBox(height: 25),

            /// ----------- ORDER INFO CARD -----------
            Container(
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
                  const SizedBox(height: 15),
                  _buildRow(
                      title: AppString.tickets,
                      value: "${order.ticketCount} x Ticket"),
                  _buildRow(
                      title: AppString.paymentMethod,
                      value: _selectedPaymentMethod),
                  const Divider(height: 25),
                  _buildRow(
                    title: AppString.totalPrice,
                    value: "\$${order.totalPrice.toStringAsFixed(2)}",
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ----------- PAYMENT METHOD SELECTION -----------
            Text(
              AppString.selectPaymentMethod,
              style: AppTextStyle.semibold18(AppColor.colorb26),
            ),
            const SizedBox(height: 10),

            _buildPaymentOption(AppString.creditDebitCard, AppIcon.mastercard),
            _buildPaymentOption(AppString.paypal, AppIcon.paypal),
            _buildPaymentOption(AppString.googlePay, AppIcon.googlepay),

            const SizedBox(height: 30),

            /// ----------- ACTION BUTTON -----------
            Center(
              child: SizedBox(
                width: size.width * 0.7,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorblFF,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketBookedScreen(
                          eventName: order.eventName,
                          paymentMethod: _selectedPaymentMethod,
                          totalPrice: order.totalPrice,
                          date: order.eventDate,
                          time: order.eventTime,
                          seat: 'A12',
                          location: order.location,
                          qrImageUrl: '',
                          eventImageUrl: order.imageUrl,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppString.placeOrder,
                    style: AppTextStyle.bold16(AppColor.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------- PAYMENT OPTION BUILDER -----------
  Widget _buildPaymentOption(String title, String svgPath) {
    return RadioListTile<String>(
      activeColor: AppColor.colorblFF,
      value: title,
      groupValue: _selectedPaymentMethod,
      onChanged: (value) {
        setState(() {
          _selectedPaymentMethod = value!;
        });
      },
      title: Text(title, style: AppTextStyle.semibold14(AppColor.colorb26)),
      secondary: SvgPicture.asset(
        svgPath,
        width: 35,
        height: 35,
      ),
    );
  }

  /// ----------- HELPER ROW -----------
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
