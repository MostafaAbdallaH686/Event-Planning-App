import 'package:flutter/material.dart';

class CustomFieldWithIcon extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final VoidCallback onTap;

  const CustomFieldWithIcon({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                TextField(
                  controller: controller,
                  readOnly: true,
                  decoration: InputDecoration(hintText: hint),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: width * 0.03),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ],
    );
  }
}