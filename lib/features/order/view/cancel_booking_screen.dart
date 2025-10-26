import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CancelBookingScreen extends StatefulWidget {
  const CancelBookingScreen({super.key});

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  String? _selectedReason;
  final TextEditingController _reasonController = TextEditingController();

  final List<String> _reasons = [
    AppString.reason1,
    AppString.reason2,
    AppString.reason3,
    AppString.reason4,
    AppString.otherReason,
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
          AppString.cancelBooking,
          style: AppTextStyle.bold20(AppColor.colorb26),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.black),
          onPressed: () => context.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.0512, vertical: size.height * 0.01875),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              AppString.pleaseSelectReasonForCancel,
              style: AppTextStyle.semibold15(AppColor.colorb26),
            ),
            SizedBox(height: size.height * 0.01875),

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

            SizedBox(height: size.height * 0.01875),

            /// Text Field
            TextField(
              controller: _reasonController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: AppString.tellUsMore,
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

            SizedBox(height: size.height * 0.05),

            /// Buttons
            Center(
              child: Column(
                children: [
                  /// Cancel Button (without popup)
                  SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.0625,
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
                              content: Text(AppString.selectReasonFirst),
                            ),
                          );
                          return;
                        }

                        context.pushReplacement(AppRoutes.bookingCancel);
                      },
                      child: Text(
                        AppString.cancelBooking,
                        style: AppTextStyle.bold16(AppColor.white),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.01875),

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
