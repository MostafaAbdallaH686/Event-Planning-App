import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/home/view/home_screen.dart';
import 'package:event_planning_app/features/order/view/cancel_booking_screen.dart';
import 'package:event_planning_app/features/order/view/view_ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///  (greentrue)
              SvgPicture.asset(
                AppIcon.greentrue,
                width: size.width * 0.3,
                height: size.width * 0.3,
              ),
              const SizedBox(height: 25),

              Text(
                AppString.congratulations,
                style: AppTextStyle.bold24(AppColor.colorb26),
              ),
              const SizedBox(height: 8),

              Text(
                "${AppString.yourTicketfor}\"${widget.eventName}\" ${AppString.bookingSuccess}",
                textAlign: TextAlign.center,
                style: AppTextStyle.regular15(AppColor.colorbr88),
              ),
              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
              const SizedBox(height: 50),

              /// 🔹 View E-Ticket Button
              SizedBox(
                width: size.width * 0.8,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorblFF,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewTicketScreen(
                          eventName: widget.eventName,
                          date: widget.date,
                          time: widget.time,
                          seat: widget.seat,
                          location: widget.location,
                          qrImageUrl: widget.qrImageUrl,
                          eventImageUrl: widget.eventImageUrl,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppString.viewETicket,
                    style: AppTextStyle.bold16(AppColor.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ///  Go to Home Button
              SizedBox(
                width: size.width * 0.8,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColor.colorblFF, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: AppColor.white,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    AppString.goToHome,
                    style: AppTextStyle.bold16(AppColor.colorblFF),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Report (Cancel Booking)
              SizedBox(
                width: size.width * 0.8,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.colorblFF,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CancelBookingScreen(),
                      ),
                    );
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
