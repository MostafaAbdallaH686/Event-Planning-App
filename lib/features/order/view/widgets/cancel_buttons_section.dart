import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/features/order/cubit/cancel_bookin_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CancelButtonsSection extends StatelessWidget {
  const CancelButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CancelBookingCubit, dynamic>(
      builder: (context, state) {
        final cubit = context.read<CancelBookingCubit>();

        return CustomTextbutton(
          text: AppString.cancelBooking,
          onpressed: () {
            if (!cubit.isReasonValid) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppString.selectReasonFirst),
                ),
              );
              return;
            }
            context.pushReplacement(AppRoutes.bookingCancel);
          },
        );
      },
    );
  }
}
