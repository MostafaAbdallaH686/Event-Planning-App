import 'package:event_planning_app/features/events/view/widgets/map_view_screen_body.dart';
import 'package:flutter/material.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: const MapViewScreenBody()),
    );
  }
}
