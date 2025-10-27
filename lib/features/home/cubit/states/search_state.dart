import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<EventSummaryModel> events;
  final String query;

  const SearchLoaded({
    required this.events,
    required this.query,
  });

  @override
  List<Object?> get props => [events, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
