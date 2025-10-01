import 'dart:async';
import 'package:event_planning_app/features/events/cubit/event_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/services/firestore_service.dart';

class EventCubit extends Cubit<EventState> {
  final FirestoreService firestoreService;
  StreamSubscription? _subscription;

  EventCubit(this.firestoreService) : super(EventInitial());

  void getEventById(String categoryId, String eventId) {
    emit(EventLoading());

    _subscription?.cancel();
    _subscription = firestoreService
        .getEventById(categoryId: categoryId, eventId: eventId)
        .listen((event) {
      if (event != null) {
        emit(EventLoaded(event));
      } else {
        emit(const EventError("Event not found"));
      }
    }, onError: (error) {
      emit(EventError(error.toString()));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
