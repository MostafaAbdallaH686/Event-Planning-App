import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/order/cubit/cancel_bookin_cubit.dart';
import 'package:event_planning_app/features/order/view/widgets/cancel_reason_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/cancel_reason_list.dart';
import 'widgets/cancel_buttons_section.dart';

class CancelBookingScreen extends StatelessWidget {
  const CancelBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CancelBookingCubit(),
      child: Scaffold(
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CancelReasonList(),
              SizedBox(height: 20),
              CancelReasonTextField(),
              SizedBox(height: 40),
              CancelButtonsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
