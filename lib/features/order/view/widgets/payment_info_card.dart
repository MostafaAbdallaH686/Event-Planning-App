import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/theme/app_text_style.dart';
import '../../../../core/utils/utils/app_string.dart';

class PaymentInfoCard extends StatelessWidget {
  final String paymentMethod;
  final double totalPrice;

  const PaymentInfoCard({
    super.key,
    required this.paymentMethod,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.0512,
        vertical: size.height * 0.0225,
      ),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.colorbl83,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRow(AppString.paymentMethod, paymentMethod),
          const SizedBox(height: 10),
          _buildRow(
            AppString.totalPaid,
            "\$${totalPrice.toStringAsFixed(2)}",
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyle.regular14(AppColor.colorbr88)),
        Text(value, style: AppTextStyle.semibold15(AppColor.colorb26)),
      ],
    );
  }
}
