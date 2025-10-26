import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:flutter/material.dart';

class EditProfileButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;

  const EditProfileButtons({
    super.key,
    required this.isLoading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Save Button
        isLoading
            ? Container(
                height: 54,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Color(0xFF2855FF),
                  strokeWidth: 2.5,
                ),
              )
            : CustomTextbutton(
                text: 'Save Changes',
                isIconAdded: true,
                onpressed: onSave,
              ),
        const SizedBox(height: 20),
      ],
    );
  }
}
