import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';

abstract class CategoryEventsState extends Equatable {
  const CategoryEventsState();

  @override
  List<Object?> get props => [];
}

class CategoryEventsInitial extends CategoryEventsState {}

class CategoryEventsLoading extends CategoryEventsState {}

class CategoryEventsLoaded extends CategoryEventsState {
  final List<EventSummaryModel> events;
  final String categoryId;
  final int currentPage;
  final bool hasMore;

  const CategoryEventsLoaded({
    required this.events,
    required this.categoryId,
    this.currentPage = 1,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [events, categoryId, currentPage, hasMore];

  CategoryEventsLoaded copyWith({
    List<EventSummaryModel>? events,
    String? categoryId,
    int? currentPage,
    bool? hasMore,
  }) {
    return CategoryEventsLoaded(
      events: events ?? this.events,
      categoryId: categoryId ?? this.categoryId,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class CategoryEventsError extends CategoryEventsState {
  final String message;

  const CategoryEventsError(this.message);

  @override
  List<Object?> get props => [message];
}
