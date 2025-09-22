//ToDo ::Mostafa:: Still have to clean code and make it reusable

import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final clamped = mq.copyWith(
      textScaleFactor: mq.textScaleFactor.clamp(1.0, 1.2),
    );

    final w = mq.size.width;
    final hPadding = w * 0.06;
    final gap = w * 0.04;

    return MediaQuery(
      data: clamped,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with back button
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
                SizedBox(height: gap),

                // Search bar with filter icon
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.tune, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: gap * 1.2),

                // Location section
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: gap * 0.5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 25),
                    const SizedBox(width: 5),
                    Text(
                      'My Current Location',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(height: gap * 1.5),

                // Events list
                Expanded(
                  child: ListView(
                    children: [
                      EventCard(
                        image: 'assets/2.png',
                        title: 'Dance party at the top of the town - 2022',
                        location: 'Bapunagar',
                      ),
                      SizedBox(height: gap),
                      EventCard(
                        image: 'assets/3.png',
                        title: 'Festival event at kudasan - 2022',
                        location: 'Gota',
                      ),
                      SizedBox(height: gap),
                      EventCard(
                        image: 'assets/4.png',
                        title: 'Party with friends at night - 2022',
                        location: 'Chandlodiya',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;

  const EventCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size.width;
    final gap = mq * 0.03;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Event image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              image,
              width: mq * 0.25,
              height: mq * 0.25,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: gap),
          // Event info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Heart icon
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
    );
  }
}
