class BookingModel {
  final String id;
  final String categoryId;
  final String title;
  final String location;
  final String date;
  final String status;
  final String imageUrl;

  BookingModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.location,
    required this.date,
    required this.status,
    required this.imageUrl,
  });

  factory BookingModel.fromDoc(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      categoryId: data['categoryId'] ?? '',
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      date: data['date']?.toDate().toString().split(' ')[0] ?? '',
      status: data['status'] ?? 'Pending',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
