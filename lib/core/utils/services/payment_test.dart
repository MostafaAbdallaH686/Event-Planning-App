// ignore_for_file: use_build_context_synchronously, unused_field
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentDialog extends StatefulWidget {
  final VoidCallback onPaymentSuccess;

  const StripePaymentDialog({super.key, required this.onPaymentSuccess});

  @override
  State<StripePaymentDialog> createState() => _StripePaymentDialogState();
}

class _StripePaymentDialogState extends State<StripePaymentDialog> {
  bool _loading = false;
  CardFieldInputDetails? _card;
  CardFormEditController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = CardFormEditController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    final details = _controller?.details;
    final isComplete = details?.complete ?? false;

    if (!isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppString.enterCardDetails)),
      );
      return;
    }

    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2)); // محاكاة الدفع

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppString.paymentSuccessful)),
    );

    widget.onPaymentSuccess();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final paddingH = size.width * 0.05;
    final paddingV = size.height * 0.02;
    final borderRadius = size.width * 0.04;
    final textFont = size.width * 0.045;
    final buttonFont = size.width * 0.04;
    final verticalSpace = size.height * 0.02;

    return Material(
      color: Colors.black54, // خلفية شفافة خفيفة
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: paddingH, vertical: paddingV),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppString.enterCardDetail,
                    style: TextStyle(
                      fontSize: textFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: verticalSpace * 0.6),

                  // ---- Card Form ----
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingH * 0.4,
                      vertical: paddingV * 0.3,
                    ),
                    child: CardFormField(
                      controller: _controller,
                      style: CardFormStyle(
                        borderColor: const Color(0xFFE0E0E0),
                        borderWidth: 1,
                        borderRadius: borderRadius.round(),
                        placeholderColor: Colors.grey,
                        cursorColor: Colors.black,
                        textColor: Colors.black,
                      ),
                      onCardChanged: (card) {
                        setState(() => _card = card);
                      },
                    ),
                  ),

                  SizedBox(height: verticalSpace * 0.9),

                  _loading
                      ? const CircularProgressIndicator()
                      : CustomTextbutton(
                          text: AppString.payNow,
                          onpressed: _pay,
                        ),

                  SizedBox(height: verticalSpace * 0.5),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppString.cancel,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: buttonFont * 0.9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
