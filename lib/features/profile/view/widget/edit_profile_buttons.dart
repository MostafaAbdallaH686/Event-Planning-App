import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/features/profile/view/change_password.dart';
import 'package:flutter/material.dart';

class EditProfileButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditProfileButtons({
    super.key,
    required this.isLoading,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Change Password Button
        CustomTextbutton(
          text: 'Change Password',
          isIconAdded: true,
          onpressed: isLoading
              ? () {}
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassword(),
                    ),
                  );
                },
        ),
        const SizedBox(height: 20),

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

        // Cancel Button
        CustomTextbutton(
          text: 'Cancel',
          isIconAdded: false,
          onpressed: isLoading ? () {} : onCancel,
        ),
      ],
    );
  }
}
