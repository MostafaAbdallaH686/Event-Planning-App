// lib/features/interests/presentation/cubit/interests_state.dart

import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/home/data/fav_interests_model.dart';

abstract class InterestsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InterestsInitial extends InterestsState {}

class InterestsLoading extends InterestsState {}

class InterestsLoaded extends InterestsState {
  final List<Category> allCategories;
  final Set<String> selectedCategoryIds;
  final int currentStep;

  InterestsLoaded({
    required this.allCategories,
    required this.selectedCategoryIds,
    this.currentStep = 2,
  });

  InterestsLoaded copyWith({
    List<Category>? allCategories,
    Set<String>? selectedCategoryIds,
    int? currentStep,
  }) {
    return InterestsLoaded(
      allCategories: allCategories ?? this.allCategories,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  bool isSelected(String categoryId) =>
      selectedCategoryIds.contains(categoryId);

  @override
  List<Object> get props => [allCategories, selectedCategoryIds, currentStep];
}

class InterestsError extends InterestsState {
  final String message;

  InterestsError(this.message);

  @override
  List<Object> get props => [message];
}
