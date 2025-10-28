class CategoryModel {
  final String id;
  final String name;

  const CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // 🐛 DEBUG: Print raw JSON
    print('═══════════════════════════════════════');
    print('📥 Parsing Category from JSON:');
    print('   Raw JSON: $json');
    print('   Keys: ${json.keys.join(", ")}');

    // Check what the 'id' field actually contains
    final rawId = json['id'];
    print('   Raw ID value: "$rawId"');
    print('   Raw ID type: ${rawId.runtimeType}');

    final rawName = json['name'];
    print('   Raw name value: "$rawName"');
    print('   Raw name type: ${rawName.runtimeType}');
    print('═══════════════════════════════════════');

    // Handle both string and numeric IDs
    String id;
    if (rawId is int) {
      id = rawId.toString();
      print('⚠️ Converted numeric ID $rawId to string "$id"');
    } else if (rawId is String) {
      id = rawId;
      print('✅ ID is already string: "$id"');
    } else {
      id = '';
      print('❌ Unknown ID type: ${rawId.runtimeType}');
    }

    return CategoryModel(
      id: id,
      name: json['name'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Category(id: "$id", name: "$name")';
}
