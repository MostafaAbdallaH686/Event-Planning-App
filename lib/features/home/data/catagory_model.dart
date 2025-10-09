class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
    );
  }
}
