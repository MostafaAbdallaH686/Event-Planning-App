import 'package:event_planning_app/features/events/cubit/state/event_state.dart';
import 'package:event_planning_app/features/events/data/repositories/event_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository _repository;

  EventCubit(this._repository) : super(EventInitial());

  /// Get event by ID (no categoryId needed for REST API)
  Future<void> getEventById(String eventId) async {
    emit(EventLoading());

    print('🔄 Loading event: $eventId');

    final result = await _repository.getEventById(eventId);

    result.fold(
      (failure) {
        print('❌ Error loading event: ${failure.message}');
        emit(EventError(failure.message));
      },
      (event) {
        print('✅ Event loaded: ${event.title}');
        emit(EventLoaded(event));
      },
    );
  }

  /// Refresh event data
  Future<void> refreshEvent(String eventId) async {
    final result = await _repository.getEventById(eventId);

    result.fold(
      (failure) {
        print('❌ Error refreshing event: ${failure.message}');
        // Keep current state on refresh error
        if (state is! EventLoaded) {
          emit(EventError(failure.message));
        }
      },
      (event) {
        print('✅ Event refreshed');
        emit(EventLoaded(event));
      },
    );
  }
}
