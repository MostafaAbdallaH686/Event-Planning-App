class EventModel {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String location;
  final DateTime dateTime;
  final String? imageUrl;
  final String? thumbnailUrl;
  final int maxAttendees;
  final bool paymentRequired;
  final double? price;
  final String status;
  final String organizerId;
  final DateTime createdAt;

  // Nested objects
  final CategoryInfo? category;
  final OrganizerInfo? organizer;
  final int registrationsCount;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.location,
    required this.dateTime,
    this.imageUrl,
    this.thumbnailUrl,
    required this.maxAttendees,
    required this.paymentRequired,
    this.price,
    required this.status,
    required this.organizerId,
    required this.createdAt,
    this.category,
    this.organizer,
    this.registrationsCount = 0,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    print('📥 Parsing event JSON: ${json.keys.join(", ")}');

    // Parse dateTime
    final dateStr = (json['dateTime'] ?? json['date'] ?? '') as String;
    final createdStr = (json['createdAt'] ?? '') as String;

    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: (json['categoryId'] ?? json['category_id'] ?? '') as String,
      location: json['location'] as String? ?? '',

      dateTime: DateTime.tryParse(dateStr)?.toLocal() ?? DateTime.now(),
      createdAt: DateTime.tryParse(createdStr)?.toLocal() ?? DateTime.now(),

      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,

      maxAttendees: (json['maxAttendees'] as num?)?.toInt() ?? 0,

      // Handle paymentRequired as boolean
      paymentRequired: json['paymentRequired'] as bool? ?? false,

      // Handle price (might be separate from paymentRequired)
      price: (json['price'] as num?)?.toDouble(),

      status: json['status'] as String? ?? 'SCHEDULED',
      organizerId: json['organizerId'] as String? ?? '',

      // Parse nested category object
      category: json['categories'] != null
          ? CategoryInfo.fromJson(json['categories'] as Map<String, dynamic>)
          : null,

      // Parse nested organizer object
      organizer: json['organizer'] != null
          ? OrganizerInfo.fromJson(json['organizer'] as Map<String, dynamic>)
          : null,

      // Parse registration count
      registrationsCount: json['_count'] != null
          ? (json['_count']['registrations'] as num?)?.toInt() ?? 0
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'location': location,
      'dateTime': dateTime.toIso8601String(),
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'maxAttendees': maxAttendees,
      'paymentRequired': paymentRequired,
      if (price != null) 'price': price,
      'status': status,
      'organizerId': organizerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper getters
  bool get isFree => !paymentRequired || (price ?? 0) == 0;
  bool get isUpcoming => dateTime.isAfter(DateTime.now());
  bool get isPast => dateTime.isBefore(DateTime.now());
  bool get isFull => registrationsCount >= maxAttendees;
  int get availableSpots => maxAttendees - registrationsCount;
  String get displayPrice =>
      isFree ? 'Free' : '\$${price?.toStringAsFixed(2) ?? '0.00'}';

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    String? location,
    DateTime? dateTime,
    String? imageUrl,
    String? thumbnailUrl,
    int? maxAttendees,
    bool? paymentRequired,
    double? price,
    String? status,
    String? organizerId,
    DateTime? createdAt,
    CategoryInfo? category,
    OrganizerInfo? organizer,
    int? registrationsCount,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      paymentRequired: paymentRequired ?? this.paymentRequired,
      price: price ?? this.price,
      status: status ?? this.status,
      organizerId: organizerId ?? this.organizerId,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
      registrationsCount: registrationsCount ?? this.registrationsCount,
    );
  }

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, price: ${displayPrice})';
  }
}

// Nested models
class CategoryInfo {
  final String id;
  final String name;

  const CategoryInfo({required this.id, required this.name});

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class OrganizerInfo {
  final String id;
  final String username;
  final String email;

  const OrganizerInfo({
    required this.id,
    required this.username,
    required this.email,
  });

  factory OrganizerInfo.fromJson(Map<String, dynamic> json) {
    return OrganizerInfo(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
      };
}
