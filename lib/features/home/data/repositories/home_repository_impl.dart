import 'package:event_planning_app/core/utils/errors/errors/exceptions.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';
import 'package:event_planning_app/core/utils/network/api_helper.dart';
import 'package:event_planning_app/features/home/data/catagory_model.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';
import 'package:event_planning_app/features/home/data/repositories/home_repository.dart';
import 'package:event_planning_app/features/home/domain/entities/home_data.dart';
import 'package:dartz/dartz.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiHelper _apiHelper;

  const HomeRepositoryImpl(this._apiHelper);

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    try {
      print('🔄 Loading home data...');

      // Fetch all data in parallel
      final results = await Future.wait([
        _fetchCategories(),
        _fetchUpcomingEvents(),
        _fetchPopularEvents(),
        _fetchInterestedEventIds(),
      ]);

      final categories = results[0] as List<CategoryModel>;
      final upcomingEvents = results[1] as List<EventSummaryModel>;
      final popularEvents = results[2] as List<EventSummaryModel>;
      final joinedEventIds = results[3] as Set<String>;

      print('✅ Home data loaded:');
      print('  - Categories: ${categories.length}');
      print('  - Upcoming: ${upcomingEvents.length}');
      print('  - Popular: ${popularEvents.length}');
      print('  - Interested: ${joinedEventIds.length}');

      final homeData = HomeData(
        categories: categories,
        upcomingEvents: upcomingEvents,
        popularEvents: popularEvents,
        recommendedEvents: upcomingEvents, // Reuse upcoming for now
        joinedEventIds: joinedEventIds,
      );

      return Right(homeData);
    } on CustomDioException catch (e) {
      print('❌ CustomDioException: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print('Stack trace: $stackTrace');
      return Left(UnexpectedFailure(message: 'Failed to load home data: $e'));
    }
  }

  @override
  Future<Either<Failure, List<EventSummaryModel>>> searchEvents({
    required String query,
    bool upcomingOnly = false,
    bool popularOnly = false,
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Don't search if query is empty
      if (query.trim().isEmpty) {
        return const Right([]);
      }

      // Build query parameters
      final queryParams = <String, String>{
        'search': query.trim(),
        'page': page.toString(),
        'limit': limit.toString(),
        if (upcomingOnly) 'upcoming': 'true',
        if (popularOnly) 'popular': 'true',
        if (categoryId != null && categoryId.isNotEmpty)
          'categoryId': categoryId,
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      print('🔍 Searching events: ${ApiEndpoint.events}?$queryString');

      final response = await _apiHelper.get(
        endPoint: '${ApiEndpoint.events}?$queryString',
        isAuth: false,
      );

      final events = _parseEventsResponse(response);

      print('✅ Found ${events.length} events for query: "$query"');
      return Right(events);
    } on CustomDioException catch (e) {
      print('❌ Search error: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      print('❌ Unexpected search error: $e');
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await _fetchCategories();
      return Right(categories);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventSummaryModel>>> getUpcomingEvents({
    int limit = 10,
  }) async {
    try {
      final events = await _fetchUpcomingEvents(limit: limit);
      return Right(events);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventSummaryModel>>> getPopularEvents({
    int limit = 10,
  }) async {
    try {
      final events = await _fetchPopularEvents(limit: limit);
      return Right(events);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventSummaryModel>>> getAllEvents({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (categoryId != null) 'categoryId': categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      print('📤 GET ${ApiEndpoint.events}?$queryString');

      final response = await _apiHelper.get(
        endPoint: '${ApiEndpoint.events}?$queryString',
        isAuth: false,
      );

      final events = _parseEventsResponse(response);

      return Right(events);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addEventToInterests(String eventId) async {
    try {
      // TODO: Implement when backend endpoint is ready
      // For now, just return success
      print('⚠️ addEventToInterests not implemented in backend yet');
      return const Right(null);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeEventFromInterests(String eventId) async {
    try {
      // TODO: Implement when backend endpoint is ready
      print('⚠️ removeEventFromInterests not implemented in backend yet');
      return const Right(null);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Set<String>>> getUserInterestedEventIds() async {
    try {
      final ids = await _fetchInterestedEventIds();
      return Right(ids);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  // ==================== Private Helpers ====================

  Future<List<CategoryModel>> _fetchCategories() async {
    try {
      print('📤 GET ${ApiEndpoint.categories}');

      final response = await _apiHelper.get(
        endPoint: ApiEndpoint.categories,
        isAuth: false,
      );

      print('📥 Categories response type: ${response.runtimeType}');

      // Handle different response formats
      List<dynamic> categoriesList;
      if (response is List) {
        categoriesList = response;
      } else if (response is Map<String, dynamic> &&
          response.containsKey('categories')) {
        categoriesList = response['categories'] as List;
      } else if (response is Map<String, dynamic> &&
          response.containsKey('data')) {
        categoriesList = response['data'] as List;
      } else {
        print('⚠️ Unexpected categories response format: $response');
        return [];
      }

      final categories = categoriesList
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print('✅ Fetched ${categories.length} categories');
      return categories;
    } catch (e) {
      print('❌ Error fetching categories: $e');
      // Return empty list instead of throwing to prevent home page crash
      return [];
    }
  }

  Future<List<EventSummaryModel>> _fetchUpcomingEvents({int limit = 10}) async {
    try {
      // Use query parameter: /events?upcoming=true
      final queryString = 'upcoming=true&limit=$limit';
      print('📤 GET ${ApiEndpoint.events}?$queryString');

      final response = await _apiHelper.get(
        endPoint: '${ApiEndpoint.events}?$queryString',
        isAuth: false,
      );

      return _parseEventsResponse(response);
    } catch (e) {
      print('❌ Error fetching upcoming events: $e');
      return [];
    }
  }

  Future<List<EventSummaryModel>> _fetchPopularEvents({int limit = 10}) async {
    try {
      // Use query parameter: /events?popular=true
      final queryString = 'popular=true&limit=$limit';
      print('📤 GET ${ApiEndpoint.events}?$queryString');

      final response = await _apiHelper.get(
        endPoint: '${ApiEndpoint.events}?$queryString',
        isAuth: false,
      );

      return _parseEventsResponse(response);
    } catch (e) {
      print('❌ Error fetching popular events: $e');
      return [];
    }
  }

  Future<Set<String>> _fetchInterestedEventIds() async {
    try {
      // TODO: Implement when backend endpoint is ready
      // For now, return empty set
      print('⚠️ User interests endpoint not implemented yet');
      return {};
    } catch (e) {
      print('❌ Error fetching interested events: $e');
      return {};
    }
  }

  /// Parse events from different possible response formats
  List<EventSummaryModel> _parseEventsResponse(dynamic response) {
    print('📥 Events response type: ${response.runtimeType}');

    List<dynamic> eventsList;

    // Handle different response formats
    if (response is List) {
      // Direct array: [event1, event2, ...]
      eventsList = response;
    } else if (response is Map<String, dynamic>) {
      // Wrapped in object
      if (response.containsKey('events')) {
        // { events: [...], pagination: {...} }
        eventsList = response['events'] as List;
      } else if (response.containsKey('data')) {
        // { data: [...] }
        eventsList = response['data'] as List;
      } else if (response.containsKey('results')) {
        // { results: [...] }
        eventsList = response['results'] as List;
      } else {
        print('⚠️ Unexpected events response format: ${response.keys}');
        return [];
      }
    } else {
      print('⚠️ Unknown response type: ${response.runtimeType}');
      return [];
    }

    final events = eventsList
        .map((json) {
          try {
            return EventSummaryModel.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            print('⚠️ Error parsing event: $e');
            print('   Event data: $json');
            return null;
          }
        })
        .whereType<EventSummaryModel>() // Filter out nulls
        .toList();

    print('✅ Parsed ${events.length} events');
    return events;
  }
}
