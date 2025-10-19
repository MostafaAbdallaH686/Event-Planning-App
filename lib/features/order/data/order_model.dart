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
}
