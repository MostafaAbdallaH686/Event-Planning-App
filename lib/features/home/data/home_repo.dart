import 'dart:async';
import 'package:async/async.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:event_planning_app/features/home/data/catagory_model.dart';
import 'package:event_planning_app/features/home/data/home_model.dart';

class HomeRepo {
  final FirestoreService _firestoreService;

  HomeRepo(this._firestoreService);

  Stream<HomeData> loadHomeData() {
    final categoriesStream =
        _firestoreService.getCategories(); // Stream<List<Category>>
    final upcomingStream =
        _firestoreService.getUpcomingEvents(); // Stream<List<EventModel>>
    final popularStream =
        _firestoreService.getPopularEvents(); // Stream<List<EventModel>>
    final recommendedStream = _firestoreService.getRecommendedEvents([
      "Design",
      "Family",
      "sports",
      "food",
      "music"
    ]); // Stream<List<EventModel>>

    return StreamZip([
      categoriesStream,
      upcomingStream,
      popularStream,
      recommendedStream,
    ]).map((List<dynamic> data) {
      return HomeData(
        categories: data[0] as List<CategoryModel>,
        upcomingEvents: data[1] as List<EventModel>,
        popularEvents: data[2] as List<EventModel>,
        recommendedEvents: data[3] as List<EventModel>,
      );
    });
  }

  Future<void> joinEvent(
      String categoryId, String eventId, String userId) async {
    await _firestoreService.joinEvent(categoryId, eventId, userId);
  }
}
