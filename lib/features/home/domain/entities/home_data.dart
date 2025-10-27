import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/home/data/catagory_model.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';

class HomeData extends Equatable {
  final List<CategoryModel> categories;
  final List<EventSummaryModel> upcomingEvents;
  final List<EventSummaryModel> popularEvents;
  final List<EventSummaryModel> recommendedEvents;
  final Set<String> joinedEventIds; // User's interested events

  const HomeData({
    required this.categories,
    required this.upcomingEvents,
    required this.popularEvents,
    required this.recommendedEvents,
    this.joinedEventIds = const {},
  });

  HomeData copyWith({
    List<CategoryModel>? categories,
    List<EventSummaryModel>? upcomingEvents,
    List<EventSummaryModel>? popularEvents,
    List<EventSummaryModel>? recommendedEvents,
    Set<String>? joinedEventIds,
  }) {
    return HomeData(
      categories: categories ?? this.categories,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      popularEvents: popularEvents ?? this.popularEvents,
      recommendedEvents: recommendedEvents ?? this.recommendedEvents,
      joinedEventIds: joinedEventIds ?? this.joinedEventIds,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        upcomingEvents,
        popularEvents,
        recommendedEvents,
        joinedEventIds,
      ];
}
