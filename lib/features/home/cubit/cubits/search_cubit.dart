import 'dart:async';

import 'package:event_planning_app/features/home/cubit/states/search_state.dart';
import 'package:event_planning_app/features/home/data/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  final HomeRepository _repository;
  Timer? _debounce;

  SearchCubit(this._repository) : super(SearchInitial());

  /// Search events with debouncing (500ms delay)
  void searchEvents(String query) {
    // Cancel previous timer
    _debounce?.cancel();

    // If query is empty, reset to initial
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    // Show loading immediately
    emit(SearchLoading());

    // Debounce: wait 500ms before searching
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  /// Perform actual search without debounce
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    print('🔍 Searching for: "$query"');

    final result = await _repository.searchEvents(
      query: query,
      limit: 50,
    );

    result.fold(
      (failure) {
        print('❌ Search failed: ${failure.message}');
        emit(SearchError(failure.message));
      },
      (events) {
        print('✅ Found ${events.length} results');
        emit(SearchLoaded(events: events, query: query));
      },
    );
  }

  /// Search with filters (no debounce)
  Future<void> searchWithFilters({
    required String query,
    bool upcomingOnly = false,
    bool popularOnly = false,
    String? categoryId,
  }) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await _repository.searchEvents(
      query: query,
      upcomingOnly: upcomingOnly,
      popularOnly: popularOnly,
      categoryId: categoryId,
      limit: 50,
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (events) => emit(SearchLoaded(events: events, query: query)),
    );
  }

  /// Clear search
  void clearSearch() {
    emit(SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
