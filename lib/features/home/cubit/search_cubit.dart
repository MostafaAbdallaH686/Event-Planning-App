// ignore_for_file: avoid_print

import 'dart:async';

import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final FirestoreService firestoreService;

  SearchCubit(this.firestoreService) : super(SearchInitial());
  StreamSubscription? _searchSubscription;
// search cubit

  void searchEvents(String query) {
    _searchSubscription?.cancel();

    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      _searchSubscription =
          firestoreService.searchEventsStream(query).listen((events) {
        emit(SearchLoaded(events));
      });
    } catch (e) {
      print("❌ Error while searching: $e");
      emit(SearchError(e.toString()));
    }
  }

// category cubit
  void getEventsByCategory(String categoryId) {
    emit(CategoryEventsLoading());
    try {
      firestoreService.getEventsByCategory(categoryId).listen((events) {
        emit(CategoryEventsLoaded(categoryId, events));
      });
    } catch (e) {
      print("❌ Error loading category events: $e");
      emit(CategoryEventsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _searchSubscription?.cancel();

    return super.close();
  }
}
