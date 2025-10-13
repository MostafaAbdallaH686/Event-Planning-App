import 'package:flutter/material.dart';


import 'package:event_planning_app/features/events/view/events_details_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Details App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xffFFFFFF),
        useMaterial3: true,
      ),
      home: const EventsDetailsScreen(),
    );
  }
}