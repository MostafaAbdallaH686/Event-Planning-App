class CreateEventInput {
  final String title;
  final String description;
  final String categoryId;
  final String categoryName;
  final String location;
  final DateTime date;
  final List<String> tags;
  final double price;
  final String imageUrl;

  const CreateEventInput({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.location,
    required this.date,
    required this.tags,
    required this.price,
    required this.imageUrl,
  });

  CreateEventInput copyWith({
    String? title,
    String? description,
    String? categoryId,
    String? categoryName,
    String? location,
    DateTime? date,
    List<String>? tags,
    double? price,
    String? imageUrl,
  }) {
    return CreateEventInput(
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      location: location ?? this.location,
      date: date ?? this.date,
      tags: tags ?? this.tags,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
