import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:event_planning_app/features/booking/data/booking_model.dart';

class BookingRepo {
  final FirestoreService firestoreService;

  BookingRepo(this.firestoreService);

  // 🟢 Stream of 5 Business Bookings (Real-time)
  Stream<List<BookingModel>> streamBusinessBookingsLimit5() {
    return firestoreService.streamBusinessEventsLimit5().map((events) {
      return events
          .map((event) => BookingModel(
                id: event.id ?? '',
                title: event.title,
                location: event.location,
                date: event.date.toString().split(' ')[0],
                status: 'Booked',
                imageUrl: event.imageUrl,
                categoryId: event.categoryId,
              ))
          .toList();
    });
  }
}
