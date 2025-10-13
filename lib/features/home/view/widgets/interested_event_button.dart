import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';

class InterestedEventButton extends StatefulWidget {
  final bool isInterested;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final Size? size;
  final String addText;
  final String removeText;

  const InterestedEventButton({
    super.key,
    required this.isInterested,
    this.onAdd,
    this.onRemove,
    this.size,
    this.addText = AppString.join,
    this.removeText = AppString.joined,
  });

  @override
  State<InterestedEventButton> createState() => _InterestedEventButtonState();
}

class _InterestedEventButtonState extends State<InterestedEventButton> {
  late bool _isInterested;

  @override
  void initState() {
    super.initState();
    _isInterested = widget.isInterested;
  }

  void _toggleInterest() {
    setState(() {
      _isInterested = !_isInterested;
    });

    if (_isInterested) {
      widget.onAdd?.call();
    } else {
      widget.onRemove?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final buttonSize = widget.size ??
        Size(
          screenSize.width * 0.2051,
          screenSize.height * 0.0375,
        );

    return TextButton(
      onPressed: _toggleInterest,
      style: TextButton.styleFrom(
        backgroundColor:
            _isInterested ? Colors.grey.shade300 : AppColor.colorbr80,
        minimumSize: buttonSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        _isInterested ? widget.removeText : widget.addText,
        style: AppTextStyle.regular12(
          _isInterested ? Colors.grey.shade700 : AppColor.white,
        ),
      ),
    );
  }
}
