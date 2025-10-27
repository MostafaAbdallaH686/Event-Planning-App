import 'package:dartz/dartz.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/home/data/catagory_model.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';
import 'package:event_planning_app/features/home/domain/entities/home_data.dart';

abstract class HomeRepository {
  /// Fetch all home data at once
  Future<Either<Failure, HomeData>> getHomeData();

  /// Fetch specific sections
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<EventSummaryModel>>> getUpcomingEvents(
      {int limit = 10});
  Future<Either<Failure, List<EventSummaryModel>>> getPopularEvents(
      {int limit = 10});
  Future<Either<Failure, List<EventSummaryModel>>> getAllEvents({
    int page = 1,
    int limit = 20,
    String? categoryId,
  });

  /// ✅ ADD THIS: Search events with filters
  Future<Either<Failure, List<EventSummaryModel>>> searchEvents({
    required String query,
    bool upcomingOnly = false,
    bool popularOnly = false,
    String? categoryId,
    int page = 1,
    int limit = 20,
  });

  /// User interests (toggle favorite/bookmark)
  Future<Either<Failure, void>> addEventToInterests(String eventId);
  Future<Either<Failure, void>> removeEventFromInterests(String eventId);
  Future<Either<Failure, Set<String>>> getUserInterestedEventIds();
}
