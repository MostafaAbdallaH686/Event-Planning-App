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
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HomeLoaded && state.data.categories.isNotEmpty) {
          return _buildCategoryList(context, state.data.categories);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryList(
      BuildContext context, List<CategoryModel> categories) {
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      height: size.height * 0.05,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.0205),
              child: CategoryItem(
                key: ValueKey(category.id),
                category: category,
                onTap: () {
                  final encodedName = Uri.encodeComponent(category.name);
                  context.push(
                      '${AppRoutes.categoryEvents}${category.id}/$encodedName');
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.0256,
          vertical: size.height * 0.0125,
        ),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            category.name,
            style: AppTextStyle.regular14(AppColor.colorbA1),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
