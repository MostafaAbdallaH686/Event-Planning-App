import 'package:event_planning_app/features/auth/view/my_profile/widget/profile_screen_body.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: const ProfileScreenBody()));
  }
}
