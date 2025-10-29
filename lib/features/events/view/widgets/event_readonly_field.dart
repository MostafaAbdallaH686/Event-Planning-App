import 'package:flutter/material.dart';
import 'event_field.dart';

class EventReadOnlyField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final VoidCallback onTap;

  const EventReadOnlyField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return EventField(
      title: title,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: IconButton(
            onPressed: onTap,
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}
