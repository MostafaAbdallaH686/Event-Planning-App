class Category {
  final String id;
  final String name;
  final String emoji;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
  });

  // Factory to parse from your string list
  factory Category.fromString(String label) {
    final parts = label.split(' ');
    final emoji = parts.last;
    final name = parts.sublist(0, parts.length - 1).join(' ');
    return Category(
      id: name.toLowerCase().replaceAll(' ', '_'),
      name: name,
      emoji: emoji,
    );
  }

  String get displayLabel => '$name $emoji';
}
