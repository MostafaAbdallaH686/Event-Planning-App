import 'dart:io';

import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
import 'package:event_planning_app/core/utils/errors/failures.dart';
import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
import 'package:event_planning_app/features/events/cubit/events_state.dart';
import 'package:event_planning_app/features/events/data/events_model.dart';
import 'package:event_planning_app/features/events/data/events_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  final EventRepository _repo;

  CreateEventCubit(this._repo) : super(CreateEventInitial());

  Future<void> submit({
    required CreateEventInput input,
    File? imageFile,
  }) async {
    // Basic validation here; UI still validates with Form as first line of defense
    final errors = _validate(input);
    if (errors.isNotEmpty) {
      emit(CreateEventValidationError(errors));
      return;
    }

    emit(CreateEventSubmitting());
    try {
      final event = await _repo.createEvent(input: input, imageFile: imageFile);
      emit(CreateEventSuccess(event));
    } on AuthFailure catch (e) {
      emit(CreateEventFailure(e.message));
    } on FirestoreFailure catch (e) {
      emit(CreateEventFailure(e.message));
    } on UnexpectedFailure catch (e) {
      emit(CreateEventFailure(e.message));
    } catch (e) {
      emit(const CreateEventFailure('Failed to create event'));
    }
  }

  Map<String, String> _validate(CreateEventInput input) {
    final errors = <String, String>{};
    if (input.title.trim().isEmpty) errors['title'] = 'Title is required';
    if (input.description.trim().isEmpty)
      errors['description'] = 'Description is required';
    if (input.location.trim().isEmpty)
      errors['location'] = 'Location is required';
    if (input.categoryId.trim().isEmpty)
      errors['category'] = 'Category is required';
    if (input.price.isNaN || input.price < 0)
      errors['price'] = 'Price must be >= 0';
    // date/time handled in UI; here we assume a valid DateTime is provided
    return errors;
  }
}
