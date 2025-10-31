import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/features/booking/data/booking_repo.dart';
import 'package:event_planning_app/features/booking/data/booking_model.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepo bookingRepo;
  StreamSubscription<List<BookingModel>>? _bookingSubscription;

  BookingCubit(this.bookingRepo) : super(BookingInitial());

  void streamBusinessBookings() {
    emit(BookingLoading());

    _bookingSubscription?.cancel();

    _bookingSubscription =
        bookingRepo.streamBusinessBookingsLimit5().listen((bookings) {
      emit(BookingSuccess(bookings));
    }, onError: (error) {
      emit(BookingFailure('Error loading bookings: $error'));
    });
  }

  @override
  Future<void> close() {
    _bookingSubscription?.cancel();
    return super.close();
  }
}
