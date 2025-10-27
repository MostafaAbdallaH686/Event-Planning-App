class EventSummaryModel {
  final String id;
  final String title;
  final String location;
  final String? imageUrl;

  const EventSummaryModel({
    required this.id,
    required this.title,
    required this.location,
    this.imageUrl,
  });

  factory EventSummaryModel.fromJson(Map<String, dynamic> json) {
    return EventSummaryModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      imageUrl:
          (json['imageUrl'] ?? json['image'] ?? json['image_url']) as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() =>
      'EventSummary(id: $id, title: $title, location: $location)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventSummaryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
