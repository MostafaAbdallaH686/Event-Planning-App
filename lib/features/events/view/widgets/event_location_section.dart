import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/order/data/order_model.dart';
import 'package:flutter/material.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_image.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:go_router/go_router.dart';

class EventLocationSection extends StatelessWidget {
  final EventModel event;
  const EventLocationSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.00512),
          child: Text(
            AppString.location,
            style: AppTextStyle.semibold18(AppColor.colorbr688),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.00512),
          child: Container(
            width: double.infinity,
            height: size.height * 0.2425,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              image: const DecorationImage(
                image: AssetImage(AppImage.map),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.0425),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1461538),
          child: CustomTextbutton(
            text: "${AppString.buytecket}  ${event.price} \$",
            onpressed: () {
              final order = OrderModel(
                eventName: event.title,
                eventDate: event.date.toString().split(' ')[0],
                eventTime:
                    "${event.date.hour}:${event.date.minute.toString().padLeft(2, '0')}",
                location: event.location,
                totalPrice: event.price,
                paymentMethod: AppString.creditDebitCard,
                ticketCount: 1,
                imageUrl: event.imageUrl,
              );
              context.push(AppRoutes.orderDetails, extra: order);
            },
          ),
        ),
      ],
    );
  }
}
