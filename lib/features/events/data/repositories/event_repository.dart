import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/events/data/models/event_model.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';

abstract class EventRepository {
  /// Create new event
  Future<Either<Failure, EventModel>> createEvent({
    required EventModel input,
    File? imageFile,
  });

  /// Get event by ID
  Future<Either<Failure, EventModel>> getEventById(String eventId);

  /// Get events by category
  Future<Either<Failure, List<EventSummaryModel>>> getEventsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  });

  /// Update event
  Future<Either<Failure, EventModel>> updateEvent({
    required String eventId,
    required EventModel input,
    File? imageFile,
  });

  /// Delete event
  Future<Either<Failure, void>> deleteEvent(String eventId);
}
