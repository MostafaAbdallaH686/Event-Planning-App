import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterestedEventButton extends StatefulWidget {
  final bool isInterested;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  final Size? size;
  final String addText;
  final String removeText;
  final String eventId;

  const InterestedEventButton({
    super.key,
    required this.isInterested,
    required this.eventId,
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
    _loadInterestState();
  }

  Future<void> _loadInterestState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('interested_${widget.eventId}');
    if (saved != null) {
      setState(() {
        _isInterested = saved;
      });
    }
  }

  Future<void> _saveInterestState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('interested_${widget.eventId}', _isInterested);
  }

  Future<void> _toggleInterest() async {
    setState(() {
      _isInterested = !_isInterested;
    });
    await _saveInterestState();

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
