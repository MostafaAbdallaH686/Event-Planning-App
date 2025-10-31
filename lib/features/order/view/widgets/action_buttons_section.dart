import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActionButtonsSection extends StatelessWidget {
  final OrderModel order;
  final String seat;
  final String qrImageUrl;

  const ActionButtonsSection({
    super.key,
    required this.order,
    required this.seat,
    required this.qrImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        CustomTextbutton(
          text: AppString.viewETicket,
          onpressed: () {
            context.push(
              AppRoutes.viewTicket,
              extra: {
                'order': order,
                'seat': seat,
                'qrImageUrl': qrImageUrl,
              },
            );
          },
        ),
        SizedBox(height: size.height * 0.025),
        CustomTextbutton(
          text: AppString.goToHome,
          onpressed: () {
            context.pushReplacement(AppRoutes.navBar);
          },
        ),
        SizedBox(height: size.height * 0.025),
        CustomTextbutton(
          text: AppString.report,
          onpressed: () {
            context.push(AppRoutes.cancelBooking);
          },
        ),
      ],
    );
  }
}
