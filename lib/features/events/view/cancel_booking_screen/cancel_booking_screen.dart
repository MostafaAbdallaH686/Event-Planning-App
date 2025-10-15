import 'package:flutter/material.dart';
import '../core/utils/theme/app_colors.dart';
import '../core/utils/theme/app_text_style.dart';
import '../features/events/view/report_cancel_screen/report_cancel_screen.dart';

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  String? _selectedReason;
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _reasons = [
    "I have a better deal",
    "Some other work, can’t come",
    "I want to book another event",
    "Venue location is too far",
    "Another reason",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Cancel Booking",
          style: AppTextStyle.bold20(AppColor.colorb26),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              "Please select the reason for cancellation",
              style: AppTextStyle.semibold15(AppColor.colorb26),
            ),
            const SizedBox(height: 15),

            /// Radio Buttons
            ..._reasons.map((reason) => RadioListTile<String>(
              activeColor: AppColor.colorblFF,
              title: Text(reason,
                  style: AppTextStyle.regular14(AppColor.colorb26)),
              value: reason,
              groupValue: _selectedReason,
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            )),

            const SizedBox(height: 15),

            /// Text Field
            TextField(
              controller: _reasonController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Tell us more about your reason...",
                hintStyle: AppTextStyle.regular14(AppColor.colorbr88),
                filled: true,
                fillColor: AppColor.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.colorbr88),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.colorblFF),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// Buttons
            Center(
              child: Column(
                children: [
                  /// Cancel Button (without popup)
                  SizedBox(
                    width: size.width * 0.7,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.colorblFF,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 6,
                      ),
                      onPressed: () {
                        if (_selectedReason == null &&
                            _reasonController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please select or write a reason first."),
                            ),
                          );
                          return;
                        }



                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BookingCancelPage()),
                        );
                      },
                      child: Text(
                        "Cancel Booking",
                        style: AppTextStyle.bold16(AppColor.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// Report Button

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
