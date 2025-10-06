import 'package:flutter/material.dart';

class MapViewScreenBody extends StatelessWidget {
  const MapViewScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: const Text('MapView Screen Body')),
    );
  }
}
