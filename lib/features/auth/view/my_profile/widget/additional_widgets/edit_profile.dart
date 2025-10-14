import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  final UserModel user;
  const EditProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Column(
        children: [
          TextField(decoration: InputDecoration(labelText: "Name")),
          TextField(decoration: InputDecoration(labelText: "Email")),
          OutlinedButton(onPressed: () {}, child: const Text("Save"))
        ],
      ),
    );
  }
}
