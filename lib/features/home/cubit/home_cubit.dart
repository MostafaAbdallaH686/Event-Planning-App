// ignore_for_file: avoid_print, depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final FirestoreService firestoreService;

  HomeCubit(this.firestoreService) : super(const HomeLoading()) {
    loadData();
  }

  void loadData() {
    emit(const HomeLoading());

    firestoreService.getCategories().listen(
      (categories) {
        firestoreService.getUpcomingEvents().listen(
          (upcomingEvents) {
            firestoreService.getPopularEvents().listen(
              (popularEvents) {
                firestoreService.getRecommendedEvents(
                    ["Design", "Family", "sports", "food", "music"]).listen(
                  (recommendedEvents) {
                    emit(HomeLoaded(
                      categories: categories,
                      upcomingEvents: upcomingEvents,
                      popularEvents: popularEvents,
                      recommendedEvents: recommendedEvents,
                      joinedEventIds: {},
                    ));
                  },
                  onError: (error) => emit(HomeError(error.toString())),
                );
              },
              onError: (error) => emit(HomeError(error.toString())),
            );
          },
          onError: (error) => emit(HomeError(error.toString())),
        );
      },
      onError: (error) => emit(HomeError(error.toString())),
    );
  }

  Future<void> joinEvent(String eventId) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      if (currentState.joinedEventIds.contains(eventId)) return;

      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        await firestoreService.joinEvent(eventId, userId);

        final updatedJoined = Set<String>.from(currentState.joinedEventIds)
          ..add(eventId);

        emit(currentState.copyWith(joinedEventIds: updatedJoined));
      } catch (e) {
        print("❌ Error joining event: $e");
      }
    }
  }
}
