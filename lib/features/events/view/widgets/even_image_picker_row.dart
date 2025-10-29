import 'dart:io';
import 'package:flutter/material.dart';

class EventImagePickerRow extends StatelessWidget {
  final File? file;
  final VoidCallback onPick;

  const EventImagePickerRow({
    super.key,
    required this.file,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final name = file != null ? file!.path.split('/').last : 'No file chosen';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upload Event Photo'),
              Text(
                name,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: onPick,
          icon: const Icon(Icons.file_upload, color: Colors.white),
          label: const Text(
            'Choose File',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
