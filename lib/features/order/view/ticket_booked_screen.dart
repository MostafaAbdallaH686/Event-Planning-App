import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';
import '../../../../core/utils/utils/app_icon.dart';

class TicketBookedScreen extends StatefulWidget {
  final String eventName;
  final String paymentMethod;
  final double totalPrice;
  final String date;
  final String time;
  final String seat;
  final String location;
  final String qrImageUrl;
  final String eventImageUrl;

  const TicketBookedScreen({
    super.key,
    required this.eventName,
    required this.paymentMethod,
    required this.totalPrice,
    required this.date,
    required this.time,
    required this.seat,
    required this.location,
    required this.qrImageUrl,
    required this.eventImageUrl,
  });

  @override
  State<TicketBookedScreen> createState() => _TicketBookedScreenState();
}

class _TicketBookedScreenState extends State<TicketBookedScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.0512, vertical: size.height * 0.03125),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///  (greentrue)
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
                "${AppString.yourTicketfor}\"${widget.eventName}\" ${AppString.bookingSuccess}",
                textAlign: TextAlign.center,
                style: AppTextStyle.regular15(AppColor.colorbr88),
              ),
              SizedBox(height: size.height * 0.0375),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.0512,
                    vertical: size.height * 0.0225),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.colorbl83,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildRow(AppString.paymentMethod, widget.paymentMethod),
                    const SizedBox(height: 10),
                    _buildRow(AppString.totalPaid,
                        "\$${widget.totalPrice.toStringAsFixed(2)}"),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.0625),

              /// 🔹 View E-Ticket Button
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorblFF,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    context.push(AppRoutes.viewTicket, extra: {
                      'eventName': widget.eventName,
                      'date': widget.date,
                      'time': widget.time,
                      'seat': widget.seat,
                      'location': widget.location,
                      'eventImageUrl': widget.eventImageUrl,
                      'qrImageUrl': widget.qrImageUrl,
                    });
                  },
                  child: Text(
                    AppString.viewETicket,
                    style: AppTextStyle.bold16(AppColor.white),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              ///  Go to Home Button
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.065,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColor.colorblFF, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: AppColor.white,
                  ),
                  onPressed: () {
                    context.pushReplacement(AppRoutes.home);
                  },
                  child: Text(
                    AppString.goToHome,
                    style: AppTextStyle.bold16(AppColor.colorblFF),
                  ),
                ),
              ),

              SizedBox(height: size.height * 0.02),

              /// 🔹 Report (Cancel Booking)
              SizedBox(
                width: size.width * 0.8,
                height: size.height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorblFF,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    context.push(AppRoutes.cancelBooking);
                  },
                  child: Text(
                    AppString.report,
                    style: AppTextStyle.bold16(AppColor.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Helper widget for Payment Rows
  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.regular14(AppColor.colorbr88)),
        Text(value, style: AppTextStyle.semibold15(AppColor.colorb26)),
      ],
    );
  }
}
