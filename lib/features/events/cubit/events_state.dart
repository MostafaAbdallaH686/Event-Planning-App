import 'package:equatable/equatable.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';

abstract class CreateEventState extends Equatable {
  const CreateEventState();

  @override
  List<Object?> get props => [];
}

class CreateEventInitial extends CreateEventState {}

class CreateEventSubmitting extends CreateEventState {}

class CreateEventSuccess extends CreateEventState {
  final EventModel event;
  const CreateEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class CreateEventFailure extends CreateEventState {
  final String message;
  const CreateEventFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateEventValidationError extends CreateEventState {
  final Map<String, String> errors;
  const CreateEventValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}
