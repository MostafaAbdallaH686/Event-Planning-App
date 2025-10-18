import 'dart:io';

import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/features/events/data/events_model.dart';

abstract class EventRepository {
  Future<EventModel> createEvent({
    required CreateEventInput input,
    File? imageFile,
  });
}
