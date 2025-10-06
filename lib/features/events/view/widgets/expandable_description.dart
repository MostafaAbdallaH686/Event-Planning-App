import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ExpandableDescription extends StatefulWidget {
  final String description;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  const ExpandableDescription({
    super.key,
    required this.description,
    this.textStyle,
    this.linkStyle,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _expanded = false;
  bool _isLong = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        // Measure if text overflows 2 lines
        final span =
            TextSpan(text: widget.description, style: widget.textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: size.maxWidth);
        _isLong = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              style: widget.textStyle,
              maxLines: _expanded ? null : 2,
              overflow:
                  _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (_isLong)
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  _expanded ? 'Read less' : 'Read more',
                  style: widget.linkStyle ??
                      widget.textStyle?.copyWith(color: AppColor.blue),
                ),
              ),
          ],
        );
      },
    );
  }
}
