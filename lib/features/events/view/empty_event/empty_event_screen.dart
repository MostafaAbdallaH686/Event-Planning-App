import 'package:event_planning_app/features/events/view/empty_event/widget/empty_event_screen_body.dart';
import 'package:flutter/material.dart';

class EmptyEventScreen extends StatelessWidget {
  const EmptyEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: const EmptyEventScreenBody()),
    );
  }
}
