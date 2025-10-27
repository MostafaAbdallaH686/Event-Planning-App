import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/home/domain/entities/home_data.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeData data;

  const HomeLoaded({required this.data});

  @override
  List<Object?> get props => [data];

  // ✅ Fixed: Access joinedEventIds from data
  Set<String> get joinedEventIds => data.joinedEventIds;

  HomeLoaded copyWith({HomeData? data}) {
    return HomeLoaded(data: data ?? this.data);
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
