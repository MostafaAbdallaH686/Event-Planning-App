// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/data/catagory_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/home_state.dart';
import 'package:go_router/go_router.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded && state.data.categories.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Categories',
                actionText: 'See All',
                onActionPressed: () {
                  context.push(AppRoutes.categoryEvents);
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.data.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.data.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CategoryChip(
                        category: category,
                        onTap: () {
                          // Navigate to category events
                          // context.push(AppRoutes.categoryEvents, extra: category.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// Category Chip Widget
class CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Text(category.name),
        backgroundColor: AppColor.border,
        labelStyle: AppTextStyle.medium14(AppColor.black),
      ),
    );
  }
}

// Section Header Widget (Reusable)
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.bold16(AppColor.black),
        ),
        if (actionText != null && onActionPressed != null)
          TextButton(
            onPressed: onActionPressed,
            child: Text(actionText!),
          ),
      ],
    );
  }
}
