import 'dart:io';
import 'package:event_planning_app/core/utils/errors/network_failure.dart';
import 'package:event_planning_app/features/events/cubit/events_state.dart';
import 'package:event_planning_app/features/events/data/events_model.dart';
import 'package:event_planning_app/features/events/data/events_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  final CreateEventRepository _repo;

  CreateEventCubit(this._repo) : super(CreateEventInitial());

  Future<void> submit({
    required EventModel input,
    File? imageFile,
  }) async {
    final errors = _validate(input);
    if (errors.isNotEmpty) {
      emit(CreateEventValidationError(errors));
      return;
    }

// Optional guard to avoid server validation round-trip
    if (input.date.isBefore(DateTime.now())) {
      emit(const CreateEventFailure('Event date cannot be in the past'));
      return;
    }

    emit(CreateEventSubmitting());
    try {
      final event = await _repo.createEvent(input: input, imageFile: imageFile);
      emit(CreateEventSuccess(event));
    } on CustomDioException catch (e) {
      emit(CreateEventFailure(e.errMessage));
    } catch (e) {
      emit(const CreateEventFailure('Failed to create event'));
    }
  }

  Map<String, String> _validate(EventModel input) {
    final errors = <String, String>{};
    if (input.title.trim().isEmpty) errors['title'] = 'Title is required';
    if (input.description.trim().isEmpty)
      errors['description'] = 'Description is required';
    if (input.location.trim().isEmpty)
      errors['location'] = 'Location is required';
    if (input.categoryId.trim().isEmpty)
      errors['category'] = 'Category is required';
    if (input.paymentRequired.isNaN || input.paymentRequired < 0)
      errors['price'] = 'Price must be >= 0';
    return errors;
  }
}
