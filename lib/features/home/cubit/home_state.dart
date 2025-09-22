import 'package:equatable/equatable.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> categories;
  final List<EventModel> upcomingEvents;
  final Set<String> joinedEventIds;
  final List<EventModel> popularEvents;
  final List<EventModel> recommendedEvents;

  const HomeLoaded({
    required this.popularEvents,
    required this.categories,
    required this.upcomingEvents,
    this.joinedEventIds = const {},
    required this.recommendedEvents,
  });

  HomeLoaded copyWith({
    List<Map<String, dynamic>>? categories,
    List<EventModel>? upcomingEvents,
    Set<String>? joinedEventIds,
    List<EventModel>? popularEvents,
    List<EventModel>? recommendedEvents,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      recommendedEvents: recommendedEvents ?? this.recommendedEvents,
      popularEvents: popularEvents ?? this.popularEvents,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      joinedEventIds: joinedEventIds ?? this.joinedEventIds,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        upcomingEvents,
        popularEvents,
        recommendedEvents,
        joinedEventIds
      ];
}
