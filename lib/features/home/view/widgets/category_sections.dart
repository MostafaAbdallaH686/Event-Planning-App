import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/features/home/cubit/cubits/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/states/home_state.dart';
import 'package:event_planning_app/features/home/data/models/catagory_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:go_router/go_router.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeLoaded) return const SizedBox.shrink();

        final categories = state.data.categories;
        if (categories.isEmpty) return const SizedBox.shrink();

        // 🐛 DEBUG: Print all categories
        print('═══════════════════════════════════════');
        print('📋 All Categories Loaded:');
        for (var cat in categories) {
          print('  Name: "${cat.name}"');
          print('  ID: "${cat.id}" (Type: ${cat.id.runtimeType})');
          print('  ---');
        }
        print('═══════════════════════════════════════');

        if (state.data.categories.isNotEmpty) {
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
                    print('🏷️ Category: ${category.name}, ID: ${category.id}');

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CategoryChip(
                        category: category,
                        onTap: () {
                          print('═══════════════════════════════════════');
                          print('🔗 NAVIGATION TRIGGERED:');
                          print('  Category Name: "${category.name}"');
                          print('  Category ID: "${category.id}"');
                          print('  ID Type: ${category.id.runtimeType}');
                          print('═══════════════════════════════════════');
                          // Navigate to category events
                          context.push(
                            AppRoutes.categoryEvents,
                            extra: {
                              'categoryId': category.id,
                              'categoryName': category.name,
                            },
                          );
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
