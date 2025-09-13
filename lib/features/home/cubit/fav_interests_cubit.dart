// lib/features/interests/presentation/cubit/interests_cubit.dart

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/cubit/fav_interests_state.dart';
import 'package:event_planning_app/features/home/data/fav_interests_model.dart';
import 'package:event_planning_app/features/home/data/fav_interests_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class InterestsCubit extends Cubit<InterestsState> {
  final InterestsRepo _repo;

  InterestsCubit(this._repo) : super(InterestsInitial()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    emit(InterestsLoading());

    try {
      // Hardcoded categories (could come from API later)
      final categories = [
        "Business 💼",
        "Community 🙌",
        "Music & Entertainment 🎶",
        "Health 💉",
        "Food & Drink 🍿",
        "Family & Education 👨‍👩‍👧‍👦",
        "Sport ⚽",
        "Fashion 👠",
        "Film & Media 🎬",
        "Home & Lifestyle 🏡",
        "Design 🎨",
        "Gaming 🎮",
        "Science & Tech 🔬",
        "School & Education 📚",
        "Holiday 🎉",
        "Travel ✈️",
      ].map(Category.fromString).toList();

      final savedIds = await _repo.getSelectedCategories();

      emit(
        InterestsLoaded(
          allCategories: categories,
          selectedCategoryIds: Set<String>.from(savedIds),
        ),
      );
    } catch (e) {
      emit(InterestsError('Failed to load categories'));
    }
  }

  void toggleCategory(Category category) {
    if (state is! InterestsLoaded) return;

    final currentState = state as InterestsLoaded;
    final newSelections = Set<String>.from(currentState.selectedCategoryIds);

    if (newSelections.contains(category.id)) {
      newSelections.remove(category.id);
    } else {
      newSelections.add(category.id);
    }

    emit(
      currentState.copyWith(
        selectedCategoryIds: newSelections,
      ),
    );
  }

  Future<void> saveAndNavigate(BuildContext context) async {
    if (state is! InterestsLoaded) return;

    final currentState = state as InterestsLoaded;

    try {
      await _repo
          .saveSelectedCategories(currentState.selectedCategoryIds.toList());
      if (context.mounted) {
        context.pushReplacement(AppRoutes.home);
      }
    } catch (e) {
      emit(InterestsError('Failed to save selections'));
    }
  }

  void setCurrentStep(int step) {
    if (state is InterestsLoaded) {
      final currentState = state as InterestsLoaded;
      emit(currentState.copyWith(currentStep: step));
    }
  }
}
