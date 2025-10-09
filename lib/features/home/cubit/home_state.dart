import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/home/data/home_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeData data;
  final Set<String> joinedEventIds;

  const HomeLoaded({
    required this.data,
    this.joinedEventIds = const {},
  });

  HomeLoaded copyWith({
    HomeData? data,
    Set<String>? joinedEventIds,
  }) {
    return HomeLoaded(
      data: data ?? this.data,
      joinedEventIds: joinedEventIds ?? this.joinedEventIds,
    );
  }

  @override
  List<Object?> get props => [data, joinedEventIds];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
