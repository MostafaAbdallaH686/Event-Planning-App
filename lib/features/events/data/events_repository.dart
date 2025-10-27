import 'dart:io';

import 'package:event_planning_app/features/events/data/events_model.dart';

abstract class CreateEventRepository {
  Future<EventModel> createEvent({
    required EventModel input,
    File? imageFile,
  });
}
