class EventModel {
  final String? id;
  final String title;
  final String description;
  final String categoryId;
  final String location;
  final DateTime date;
  final String? image;
  final int maxAttendees;
  final double paymentRequired;

  EventModel({
    this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.location,
    required this.date,
    this.image,
    required this.maxAttendees,
    required this.paymentRequired,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // 🐛 DEBUG: Print the actual JSON response
    print('📥 Parsing JSON: ${json.keys.join(", ")}');

    // Handle date field (multiple possible names)
    final dateStr = (json['dateTime'] ?? json['date'] ?? '') as String;

    // 🔧 FIXED: Robust payment parsing
    double parsePayment(dynamic value) {
      if (value == null) return 0.0;

      // If it's already a number
      if (value is num) return value.toDouble();

      // If it's a boolean (backend uses true/false for "requires payment")
      if (value is bool) {
        print('⚠️ paymentRequired is bool: $value (converting to 0.0)');
        return 0.0; // or handle differently based on your needs
      }

      // If it's a string, try to parse
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }

      print('⚠️ Unknown paymentRequired type: ${value.runtimeType}');
      return 0.0;
    }

    // 🔧 FIXED: Robust integer parsing
    int parseMaxAttendees(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return EventModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',

      // Support both camelCase and snake_case
      categoryId: (json['categoryId'] ?? json['category_id'] ?? '') as String,

      location: json['location'] as String? ?? '',

      date: DateTime.tryParse(dateStr)?.toLocal() ?? DateTime.now(),

      // Try multiple possible field names for image
      image:
          (json['image'] ?? json['imageUrl'] ?? json['image_url']) as String?,

      maxAttendees: parseMaxAttendees(
          json['maxAttendees'] ?? json['max_attendees'] ?? json['capacity']),

      // Try multiple field names and handle type mismatches
      paymentRequired: parsePayment(
          json['paymentRequired'] ?? json['payment_required'] ?? json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'location': location,
      'dateTime': date.toIso8601String(),
      if (image != null) 'image': image,
      'maxAttendees': maxAttendees,
      'paymentRequired': paymentRequired,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? categoryId,
    String? location,
    DateTime? date,
    String? image,
    int? maxAttendees,
    double? paymentRequired,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      location: location ?? this.location,
      date: date ?? this.date,
      image: image ?? this.image,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      paymentRequired: paymentRequired ?? this.paymentRequired,
    );
  }

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, maxAttendees: $maxAttendees, paymentRequired: \$$paymentRequired)';
  }
}
