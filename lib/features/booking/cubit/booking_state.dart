import 'package:event_planning_app/features/booking/data/booking_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<BookingModel> bookings;
  BookingSuccess(this.bookings);
}

class BookingFailure extends BookingState {
  final String error;
  BookingFailure(this.error);
}
