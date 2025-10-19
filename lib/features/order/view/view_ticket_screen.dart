// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';
//import '../review_page/review_page.dart';

class ViewTicketScreen extends StatelessWidget {
  final String eventName;
  final String date;
  final String time;
  final String seat;
  final String location;
  final String eventImageUrl;

  const ViewTicketScreen({
    super.key,
    required this.eventName,
    required this.date,
    required this.time,
    required this.seat,
    required this.location,
    required this.eventImageUrl,
    required String qrImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.4,
              child: eventImageUrl.isNotEmpty
                  ? Image.network(eventImageUrl, fit: BoxFit.cover)
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
                onTap: () => Navigator.pop(context),
                child:
                    const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              ),
            ),
            Positioned(
              top: 157,
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                    Text(
                      AppString.viewTicket,
                      style: AppTextStyle.bold24(AppColor.colorb26),
                    ),
                    const SizedBox(height: 15),

                    /// 🔹 QR Placeholder
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColor.colorblFF.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.colorblFF.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code_2,
                          color: AppColor.colorblFF,
                          size: 60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    Text(
                      eventName,
                      style: AppTextStyle.bold21(AppColor.colorb26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      location,
                      style: AppTextStyle.regular16(AppColor.colorbr88),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppString.date,
                                style:
                                    AppTextStyle.regular14(AppColor.colorbr88)),
                            Text(date,
                                style:
                                    AppTextStyle.semibold15(AppColor.colorb26)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(AppString.time,
                                style:
                                    AppTextStyle.regular14(AppColor.colorbr88)),
                            Text(time,
                                style:
                                    AppTextStyle.semibold15(AppColor.colorb26)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppString.seat,
                            style: AppTextStyle.regular14(AppColor.colorbr88)),
                        Text(seat,
                            style: AppTextStyle.semibold15(AppColor.colorb26)),
                      ],
                    ),
                    const Spacer(),

                    /// ة ReviewPage
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.colorblFF,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          // لو حد عاملها يباصيها هنا لو سمحت
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ReviewPage()),
                          );*/
                        },
                        child: Text(
                          AppString.rateUs,
                          style: AppTextStyle.bold16(AppColor.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
