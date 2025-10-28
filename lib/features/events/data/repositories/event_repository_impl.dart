import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:event_planning_app/core/utils/errors/errors/exceptions.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';
import 'package:event_planning_app/core/utils/network/api_helper.dart';
import 'package:event_planning_app/features/events/data/models/event_model.dart';
import 'package:event_planning_app/features/events/data/repositories/event_repository.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';

class EventRepositoryImpl implements EventRepository {
  final ApiHelper _apiHelper;

  const EventRepositoryImpl(this._apiHelper);

  @override
  Future<Either<Failure, EventModel>> getEventById(String eventId) async {
    try {
      print('📤 GET ${ApiEndpoint.events}/$eventId');

      final response = await _apiHelper.get(
        endPoint: '${ApiEndpoint.events}/$eventId',
        isAuth: false, // Public endpoint
      );

      print('📥 Event response: ${response.runtimeType}');

      if (response is Map<String, dynamic>) {
        final event = EventModel.fromJson(response);
        print('✅ Event loaded: ${event.title}');
        return Right(event);
      }

      return const Left(UnexpectedFailure(
        message: 'Unexpected response format',
      ));
    } on CustomDioException catch (e) {
      print('❌ Error fetching event: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print('Stack trace: $stackTrace');
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> createEvent({
    required EventModel input,
    File? imageFile,
  }) async {
    try {
      final fields = <String, dynamic>{
        'title': input.title.trim(),
        'description': input.description.trim(),
        'categoryId': input.categoryId,
        'location': input.location.trim(),
        'dateTime': input.dateTime.toUtc().toIso8601String(),
        'maxAttendees': input.maxAttendees,
        'paymentRequired': input.paymentRequired,
        if (input.price != null) 'price': input.price,
      };

      print('🚀 Creating event: ${input.title}');

      final json = await _apiHelper.postMultipart(
        endPoint: ApiEndpoint.events,
        fields: fields,
        file: imageFile,
        fileField: 'image',
        isAuth: true,
        onSendProgress: (sent, total) {
          final percent = (sent / total * 100).toStringAsFixed(0);
          print('📤 Upload progress: $percent%');
        },
      );

      if (json is Map<String, dynamic>) {
        print('✅ Event created successfully!');
        return Right(EventModel.fromJson(json));
      }

      return const Left(UnexpectedFailure(
        message: 'Unexpected response format',
      ));
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      print('❌ Create event error: $e');
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventSummaryModel>>> getEventsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryString = 'categoryId=$categoryId&page=$page&limit=$limit';
      print('📤 GET ${ApiEndpoint.events}?$queryString');

      final response = await _apiHelper.get(
        endPoint: '${ApiEndpoint.events}?$queryString',
        isAuth: false,
      );

      // Parse response (handle both List and Object formats)
      final List<EventSummaryModel> events;
      if (response is List) {
        events = response
            .map((json) =>
                EventSummaryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response is Map<String, dynamic> &&
          response.containsKey('events')) {
        events = (response['events'] as List)
            .map((json) =>
                EventSummaryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print('⚠️ Unexpected response format: ${response.runtimeType}');
        events = [];
      }

      print('✅ Fetched ${events.length} events for category: $categoryId');
      return Right(events);
    } on CustomDioException catch (e) {
      print('❌ Error: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      print('❌ Unexpected error: $e');
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> updateEvent({
    required String eventId,
    required EventModel input,
    File? imageFile,
  }) async {
    try {
      // TODO: Implement when backend endpoint is ready
      return const Left(UnexpectedFailure(
        message: 'Update event not implemented yet',
      ));
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      await _apiHelper.delete(
        endPoint: '${ApiEndpoint.events}/$eventId',
        isAuth: true,
      );

      print('✅ Event deleted: $eventId');
      return const Right(null);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
