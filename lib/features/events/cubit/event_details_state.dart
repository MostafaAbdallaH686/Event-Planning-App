import 'package:equatable/equatable.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final EventModel event;

  const EventLoaded(this.event);

  @override
  List<Object?> get props => [event];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}
