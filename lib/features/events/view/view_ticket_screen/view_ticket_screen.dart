import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/utils/theme/app_colors.dart';
import '../../../core/utils/theme/app_text_style.dart';

class ViewTicketScreen extends StatefulWidget {
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
    required this.eventImageUrl, required String qrImageUrl,
  });

  @override
  State<ViewTicketScreen> createState() => _ViewTicketScreenState();
}

class _ViewTicketScreenState extends State<ViewTicketScreen> {
  double rating = 0; // ⭐ لتخزين عدد النجوم المختارة

  void _showRateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Rate Us",
                  style: AppTextStyle.bold20(AppColor.colorb26),
                ),
                const SizedBox(height: 10),
                Text(
                  "How was your experience?",
                  style: AppTextStyle.regular16(AppColor.colorbr88),
                ),
                const SizedBox(height: 20),

                /// ⭐ نجوم التقييم
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return IconButton(
                      onPressed: () {
                        setState(() => rating = starIndex.toDouble());
                        Navigator.pop(context);
                        _showRateDialog(); // إعادة فتح الحوار للتحديث الفوري
                      },
                      icon: Icon(
                        Icons.star,
                        size: 36,
                        color: starIndex <= rating
                            ? AppColor.colorblFF
                            : Colors.grey[300],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                /// زر الإرسال
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.colorblFF,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Thank you for rating us $rating ⭐",
                            style: AppTextStyle.regular14(AppColor.white),
                          ),
                          backgroundColor: AppColor.colorblFF,
                        ),
                      );
                    },
                    child: Text(
                      "Submit",
                      style: AppTextStyle.bold16(AppColor.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// 🔹 خلفية الصورة
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size.height * 0.4,
              child: widget.eventImageUrl.isNotEmpty
                  ? Image.network(widget.eventImageUrl, fit: BoxFit.cover)
                  : Container(
                color: AppColor.colorblFF.withOpacity(0.1),
                child: const Center(
                  child: Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
            ),

            /// 🔹 زر الرجوع
            Positioned(
              top: 12,
              left: 20,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
              ),
            ),

            /// 🔹 الكارت الرئيسي
            Positioned(
              top: 157,
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.cardShadowColor,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// 🎫 العنوان
                    Text(
                      "View Ticket",
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

                    /// 🔹 اسم الحدث
                    Text(
                      widget.eventName,
                      style: AppTextStyle.bold21(AppColor.colorb26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    /// 🔹 المكان
                    Text(
                      widget.location,
                      style: AppTextStyle.regular16(AppColor.colorbr88),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    /// 🔹 التاريخ والوقت
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date", style: AppTextStyle.regular14(AppColor.colorbr88)),
                            Text(widget.date, style: AppTextStyle.semibold15(AppColor.colorb26)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Time", style: AppTextStyle.regular14(AppColor.colorbr88)),
                            Text(widget.time, style: AppTextStyle.semibold15(AppColor.colorb26)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    /// 🔹 المقعد
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Seat", style: AppTextStyle.regular14(AppColor.colorbr88)),
                        Text(widget.seat, style: AppTextStyle.semibold15(AppColor.colorb26)),
                      ],
                    ),
                    const Spacer(),

                    /// ⭐ زر التقييم
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
                        onPressed: _showRateDialog,
                        child: Text(
                          "Rate Us",
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
