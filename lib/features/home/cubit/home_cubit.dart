// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:event_planning_app/features/home/data/home_model.dart';
import 'package:event_planning_app/features/home/data/home_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _repo;
  StreamSubscription<HomeData>? _dataSubscription;

  HomeCubit(this._repo) : super(HomeInitial()) {
    loadData();
  }

  void loadData() {
    emit(HomeLoading());

    _dataSubscription?.cancel();
    _dataSubscription = _repo.loadHomeData().listen(
      (data) {
        emit(HomeLoaded(data: data));
      },
      onError: (error) {
        print("❌ Error loading home data: $error");
        emit(HomeError(error.toString()));
      },
    );
  }

  Future<void> joinEvent(String categoryId, String eventId) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    if (currentState.joinedEventIds.contains(eventId)) return;

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      await _repo.joinEvent(categoryId, eventId, userId);

      final updatedJoined = Set<String>.from(currentState.joinedEventIds)
        ..add(eventId);

      emit(currentState.copyWith(joinedEventIds: updatedJoined));
      print("✅ Event $eventId joined successfully");
    } catch (e) {
      print("❌ Error joining event: $e");
      // Optionally emit an error state or snackbar
    }
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    return super.close();
  }
}
