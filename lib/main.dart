// ToDo:: Temporary Main for Testing OrderDetailsScreen
import 'package:flutter/material.dart';
import 'core/utils/model/user_model.dart';
import 'features/events/view/order_details_screen/order_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // مثال بيانات وهمية لتجربة الشاشة
    final dummyOrder = OrderModel(
      eventName: "AI & Flutter Tech Summit",
      eventDate: "30 September 2025",
      eventTime: "Tuesday, 10:00 AM - 5:00 PM",
      location: "Cairo International Convention Center",
      imageUrl: "assets/images/singer.png",
      totalPrice: 299.99,
      paymentMethod: "Credit / Debit Card",
      ticketCount: 2,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order Details App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xffFFFFFF),
        useMaterial3: true,
      ),
      home: OrderDetailsScreen(order: dummyOrder),
    );
  }
}
