// ignore_for_file: deprecated_member_use

import 'package:event_planning_app/core/utils/utils/app_routes.dart';
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
    final size = MediaQuery.of(context).size;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoaded && state.categories.isNotEmpty) {
          return SizedBox(
            height: size.height * 0.05,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                final categoryName = (category["name"] ?? "No name").toString();
                final categoryId = (category["id"] ?? "").toString();
                return InkWell(
                  onTap: () {
                    context.push(
                        '${AppRoutes.categoryEvents}$categoryId/$categoryName');
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: size.width * 0.0205),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.0256,
                        vertical: size.height * 0.0125),
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
                      child: Text(categoryName,
                          style: AppTextStyle.regular14(AppColor.colorbA1),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
