class OrderModel {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String location;
  final double totalPrice;
  late final String paymentMethod;
  final int ticketCount;
  final String imageUrl;

  OrderModel({
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.totalPrice,
    required this.paymentMethod,
    required this.ticketCount,
    required this.imageUrl,
  });

  OrderModel copyWith({
    String? eventName,
    String? eventDate,
    String? eventTime,
    String? location,
    double? totalPrice,
    String? paymentMethod,
    int? ticketCount,
    String? imageUrl,
  }) {
    return OrderModel(
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      location: location ?? this.location,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      ticketCount: ticketCount ?? this.ticketCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
