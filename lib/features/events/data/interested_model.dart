import 'package:event_planning_app/core/utils/model/event_model.dart';

class InterestedEvent {
  final String id;
  final String eventId;
  final String categoryId;
  final String title;
  final String description;
  final dynamic date;
  final String location;
  final String imageUrl;
  final dynamic createdAt;
  final int attendeesCount;
  final String organizerId;
  final bool isPopular;
  final List<dynamic> tags;
  final num? price;
  final String categoryName;

  InterestedEvent({
    required this.id,
    required this.eventId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.createdAt,
    required this.attendeesCount,
    required this.organizerId,
    required this.isPopular,
    required this.tags,
    required this.price,
    required this.categoryName,
  });

  factory InterestedEvent.fromMap(Map<String, dynamic> map) {
    return InterestedEvent(
      id: map['id']?.toString() ?? '',
      eventId: map['eventId']?.toString() ?? '',
      categoryId: map['categoryId']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      date: map['date'],
      location: map['location']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      createdAt: map['createdAt'],
      attendeesCount: (map['attendeesCount'] is int)
          ? map['attendeesCount'] as int
          : (map['attendeesCount'] is num)
              ? (map['attendeesCount'] as num).toInt()
              : 0,
      organizerId: map['organizerId']?.toString() ?? '',
      isPopular: map['isPopular'] == true,
      tags:
          (map['tags'] is List) ? List<dynamic>.from(map['tags']) : <dynamic>[],
      price: map['price'] is num ? map['price'] as num : null,
      categoryName: map['categoryName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventId': eventId,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'attendeesCount': attendeesCount,
      'organizerId': organizerId,
      'isPopular': isPopular,
      'tags': tags,
      'price': price,
      'categoryName': categoryName,
    };
  }

  EventModel toEventModel() {
    return EventModel(
      id: eventId,
      title: title,
      description: description,
      categoryId: categoryId,
      categoryName: categoryName,
      location: location,
      date: date is DateTime
          ? date
          : DateTime.tryParse(date.toString()) ?? DateTime.now(),
      createdAt: createdAt is DateTime
          ? createdAt
          : DateTime.tryParse(createdAt.toString()) ?? DateTime.now(),
      organizerId: organizerId,
      imageUrl: imageUrl,
      attendeesCount: attendeesCount,
      isPopular: isPopular,
      tags: tags.map((e) => e.toString()).toList(),
      price: (price ?? 0).toDouble(),
    );
  }
}
