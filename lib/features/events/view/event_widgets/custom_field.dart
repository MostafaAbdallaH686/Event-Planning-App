import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String title;
  final String hint;

  const CustomField({super.key, required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          TextField(
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}