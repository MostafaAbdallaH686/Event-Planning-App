// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
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
        print(" Error loading home data: $error");
        emit(HomeError(error.toString()));
      },
    );
  }

  Future<void> toggleInterestEvent({
    required String categoryId,
    required String eventId,
    required EventModel event,
  }) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (currentState.joinedEventIds.contains(eventId)) {
      try {
        await _repo.removeInterestedEvent(
          userId: userId,
          eventId: eventId,
        );

        final updatedInterested = Set<String>.from(currentState.joinedEventIds)
          ..remove(eventId);

        emit(currentState.copyWith(joinedEventIds: updatedInterested));
        print(" Event $eventId removed from interests");
      } catch (e) {
        print(" Error removing interest: $e");
      }
    } else {
      try {
        await _repo.addInterestedEvent(
          userId: userId,
          categoryId: categoryId,
          eventId: eventId,
          event: event,
        );

        final updatedInterested = Set<String>.from(currentState.joinedEventIds)
          ..add(eventId);

        emit(currentState.copyWith(joinedEventIds: updatedInterested));
        print("Event $eventId added to interests");
      } catch (e) {
        print("Error adding interest: $e");
      }
    }
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    return super.close();
  }
}
