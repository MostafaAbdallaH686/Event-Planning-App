import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/order/cubit/cancel_bookin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelReasonTextField extends StatelessWidget {
  const CancelReasonTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 5,
      onChanged: (text) {
        context.read<CancelBookingCubit>().updateReasonText(text);
      },
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
    );
  }
}
