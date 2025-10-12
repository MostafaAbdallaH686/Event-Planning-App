import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';

class InterestedEventButton extends StatefulWidget {
  final bool isJoined;
  final VoidCallback? onPressed;
  final Size? size;
  final String joinText;
  final String joinedText;

  const InterestedEventButton({
    super.key,
    required this.isJoined,
    required this.onPressed,
    this.size,
    this.joinText = AppString.join,
    this.joinedText = AppString.joined,
  });

  @override
  State<InterestedEventButton> createState() => _InterestedEventButtonState();
}

class _InterestedEventButtonState extends State<InterestedEventButton> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = widget.size ??
        Size(
          screenSize.width * 0.2051,
          screenSize.height * 0.0375,
        );

    return TextButton(
      onPressed: widget.isJoined ? null : widget.onPressed,
      style: TextButton.styleFrom(
        backgroundColor: widget.isJoined ? Colors.grey : AppColor.colorbr80,
        disabledBackgroundColor: Colors.grey.shade300,
        minimumSize: buttonSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        widget.isJoined ? widget.joinedText : widget.joinText,
        style: AppTextStyle.regular12(
          widget.isJoined ? Colors.grey.shade600 : AppColor.white,
        ),
      ),
    );
  }
}
