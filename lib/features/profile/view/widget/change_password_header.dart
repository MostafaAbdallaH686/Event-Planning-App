import 'package:flutter/material.dart';

class ChangePasswordHeader extends StatelessWidget {
  final String? profileImageUrl;

  const ChangePasswordHeader({
    super.key,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
          backgroundImage:
              profileImageUrl != null && profileImageUrl!.isNotEmpty
                  ? NetworkImage(profileImageUrl!)
                  : null,
          child: profileImageUrl == null || profileImageUrl!.isEmpty
              ? Icon(Icons.person, size: 50, color: Colors.grey.shade400)
              : null,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
