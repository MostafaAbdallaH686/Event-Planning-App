// category_events_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/home/cubit/cubits/category_events_cubit.dart';
import 'package:event_planning_app/features/home/cubit/states/category_events_state.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryEventsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryEventsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    // 🐛 DEBUG: Verify what we received
    print('📍 CategoryEventsScreen initialized:');
    print('   categoryId: "$categoryId"');
    print('   categoryName: "$categoryName"');
    return BlocProvider(
      create: (context) =>
          CategoryEventsCubit(getIt())..loadCategoryEvents(categoryId),
      child: CategoryEventsView(
        categoryId: categoryId,
        categoryName: categoryName,
      ),
    );
  }
}

class CategoryEventsView extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryEventsView({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryEventsView> createState() => _CategoryEventsViewState();
}

class _CategoryEventsViewState extends State<CategoryEventsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom
      context.read<CategoryEventsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: AppTextStyle.bold20(AppColor.black),
        ),
      ),
      body: BlocBuilder<CategoryEventsCubit, CategoryEventsState>(
        builder: (context, state) {
          return switch (state) {
            CategoryEventsInitial() => const _InitialView(),
            CategoryEventsLoading() => const _LoadingView(),
            CategoryEventsLoaded() => _LoadedView(
                state: state,
                categoryId: widget.categoryId,
                scrollController: _scrollController,
              ),
            CategoryEventsError() => _ErrorView(
                message: state.message,
                categoryId: widget.categoryId,
              ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

// ==================== State Views ====================

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _LoadedView extends StatelessWidget {
  final CategoryEventsLoaded state;
  final String categoryId;
  final ScrollController scrollController;

  const _LoadedView({
    required this.state,
    required this.categoryId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final events = state.events;

    if (events.isEmpty) {
      return _EmptyView(categoryId: categoryId);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<CategoryEventsCubit>().refreshEvents(categoryId);
      },
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: events.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at bottom if has more
          if (index == events.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final event = events[index];
          return _EventCard(event: event);
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String categoryId;

  const _EmptyView({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new events',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<CategoryEventsCubit>().refreshEvents(categoryId);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final String categoryId;

  const _ErrorView({
    required this.message,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load events',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<CategoryEventsCubit>()
                    .loadCategoryEvents(categoryId);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Event Card ====================

class _EventCard extends StatelessWidget {
  final EventSummaryModel event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          context.push(
            AppRoutes.eventDetails,
            extra: {"eventId": event.id},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: event.imageUrl ?? '',
                  width: size.width * 0.25,
                  height: size.height * 0.12,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.event,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Event Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event.title,
                      style: AppTextStyle.bold16(AppColor.black),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style: AppTextStyle.regular12(AppColor.colorbr688),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
