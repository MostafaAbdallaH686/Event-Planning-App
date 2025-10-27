import 'package:event_planning_app/features/home/cubit/states/home_state.dart';
import 'package:event_planning_app/features/home/data/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  /// Load home data on startup
  Future<void> loadHomeData() async {
    emit(HomeLoading());

    final result = await _repository.getHomeData();

    result.fold(
      (failure) {
        print('❌ Error loading home data: ${failure.message}');
        emit(HomeError(failure.message));
      },
      (data) {
        print('✅ Home data loaded successfully');
        print('  - Categories: ${data.categories.length}');
        print('  - Upcoming: ${data.upcomingEvents.length}');
        print('  - Popular: ${data.popularEvents.length}');
        print('  - Recommended: ${data.recommendedEvents.length}');
        emit(HomeLoaded(data: data));
      },
    );
  }

  /// Refresh home data (pull-to-refresh)
  Future<void> refreshHomeData() async {
    // Don't show loading on refresh
    final result = await _repository.getHomeData();

    result.fold(
      (failure) {
        print('❌ Error refreshing home data: ${failure.message}');
        // Keep current state on refresh error
        if (state is! HomeLoaded) {
          emit(HomeError(failure.message));
        }
      },
      (data) {
        print('✅ Home data refreshed');
        emit(HomeLoaded(data: data));
      },
    );
  }

  /// Toggle event interest (optimistic update)
  Future<void> toggleInterestEvent(String eventId) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final isInterested = currentState.data.joinedEventIds.contains(eventId);

    // Optimistic update
    final updatedIds = Set<String>.from(currentState.data.joinedEventIds);
    if (isInterested) {
      updatedIds.remove(eventId);
    } else {
      updatedIds.add(eventId);
    }

    emit(HomeLoaded(
      data: currentState.data.copyWith(joinedEventIds: updatedIds),
    ));

    // Call API
    final result = isInterested
        ? await _repository.removeEventFromInterests(eventId)
        : await _repository.addEventToInterests(eventId);

    result.fold(
      (failure) {
        print('❌ Error toggling interest: ${failure.message}');
        // Revert optimistic update on error
        emit(currentState);
      },
      (_) {
        print('✅ Interest toggled for event: $eventId');
      },
    );
  }
}
