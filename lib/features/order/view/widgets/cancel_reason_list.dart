import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/order/cubit/cancel_bookin_cubit.dart';
import 'package:event_planning_app/features/order/cubit/cancel_booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelReasonList extends StatelessWidget {
  const CancelReasonList({super.key});

  @override
  Widget build(BuildContext context) {
    final reasons = [
      AppString.reason1,
      AppString.reason2,
      AppString.reason3,
      AppString.reason4,
      AppString.otherReason,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.pleaseSelectReasonForCancel,
          style: AppTextStyle.semibold15(AppColor.colorb26),
        ),
        const SizedBox(height: 10),
        BlocBuilder<CancelBookingCubit, CancelBookingState>(
          builder: (context, state) {
            return Column(
              children: reasons.map((reason) {
                return RadioListTile<String>(
                  activeColor: AppColor.colorblFF,
                  title: Text(reason,
                      style: AppTextStyle.regular14(AppColor.colorb26)),
                  value: reason,
                  groupValue: state.selectedReason,
                  onChanged: (value) {
                    context.read<CancelBookingCubit>().selectReason(value!);
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
