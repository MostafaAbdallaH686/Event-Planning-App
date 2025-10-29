import 'package:flutter/material.dart';

class EventField extends StatelessWidget {
  final String title;
  final Widget child;

  const EventField({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
