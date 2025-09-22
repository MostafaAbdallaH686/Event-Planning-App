// lib/models/event_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String? id;
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final String location;
  final DateTime date;
  final DateTime createdAt;
  final String organizerId;
  final String imageUrl;
  final int attendeesCount;
  final bool isPopular;
  final List<String> tags;

  EventModel({
    this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.location,
    required this.date,
    required this.createdAt,
    required this.organizerId,
    required this.imageUrl,
    required this.attendeesCount,
    required this.isPopular,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'location': location,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'organizerId': organizerId,
      'imageUrl': imageUrl,
      'attendeesCount': attendeesCount,
      'isPopular': isPopular,
      'tags': tags,
    };
  }

  factory EventModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      location: data['location'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      organizerId: data['organizerId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      attendeesCount: (data['attendeesCount'] ?? 0).toInt(),
      isPopular: data['isPopular'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}
