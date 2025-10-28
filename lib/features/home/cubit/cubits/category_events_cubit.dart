import 'package:event_planning_app/features/events/data/repositories/event_repository.dart';
import 'package:event_planning_app/features/home/cubit/states/category_events_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryEventsCubit extends Cubit<CategoryEventsState> {
  final EventRepository _repository;

  CategoryEventsCubit(this._repository) : super(CategoryEventsInitial());

  /// Load events for a category
  Future<void> loadCategoryEvents(String categoryId, {int page = 1}) async {
    if (page == 1) {
      emit(CategoryEventsLoading());
    }

    print('🔄 Loading events for category: $categoryId (page: $page)');

    final result = await _repository.getEventsByCategory(
      categoryId,
      page: page,
      limit: 20,
    );

    result.fold(
      (failure) {
        print('❌ Error loading category events: ${failure.message}');
        emit(CategoryEventsError(failure.message));
      },
      (events) {
        print('✅ Loaded ${events.length} events for category: $categoryId');

        final currentState = state;
        if (currentState is CategoryEventsLoaded && page > 1) {
          // Append to existing events (pagination)
          final allEvents = [...(currentState.events), ...(events)];
          emit(CategoryEventsLoaded(
            events: allEvents,
            categoryId: categoryId,
            currentPage: page,
            hasMore: events.length >= 20,
          ));
        } else {
          // First page or refresh
          emit(CategoryEventsLoaded(
            events: events,
            categoryId: categoryId,
            currentPage: page,
            hasMore: events.length >= 20,
          ));
        }
      },
    );
  }

  /// Refresh events
  Future<void> refreshEvents(String categoryId) async {
    await loadCategoryEvents(categoryId, page: 1);
  }

  /// Load more events (pagination)
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is CategoryEventsLoaded && currentState.hasMore) {
      await loadCategoryEvents(
        currentState.categoryId,
        page: currentState.currentPage + 1,
      );
    }
  }
}
