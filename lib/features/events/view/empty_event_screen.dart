import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/events/view/widgets/empty_event_screen_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmptyEventScreen extends StatelessWidget {
  const EmptyEventScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppString.events,
          style: AppTextStyle.bold24(AppColor.colorbA1),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColor.colorb18),
            onPressed: () {},
          )
        ],
      ),
      body: EmptyEventScreenBody(userId: userId),
    );
  }
}
