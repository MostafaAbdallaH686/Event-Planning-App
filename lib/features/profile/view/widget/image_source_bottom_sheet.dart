import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  final Function(ImageSource) onSourceSelected;
  final bool hasImage;
  final VoidCallback onRemove;

  const ImageSourceBottomSheet({
    super.key,
    required this.onSourceSelected,
    required this.hasImage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Choose Photo',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Color(0xFF2855FF)),
            title: const Text('Camera'),
            onTap: () {
              context.pop();
              onSourceSelected(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Color(0xFF2855FF)),
            title: const Text('Gallery'),
            onTap: () {
              context.pop();
              onSourceSelected(ImageSource.gallery);
            },
          ),
          if (hasImage)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Photo'),
              onTap: () {
                context.pop();
                onRemove();
              },
            ),
        ],
      ),
    );
  }
}
