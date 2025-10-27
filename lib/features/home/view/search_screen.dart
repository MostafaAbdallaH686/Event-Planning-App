// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/theme/app_text_style.dart';
import 'package:event_planning_app/core/utils/utils/app_icon.dart';
import 'package:event_planning_app/core/utils/utils/app_routes.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textform.dart';
import 'package:event_planning_app/features/home/cubit/cubits/search_cubit.dart';
import 'package:event_planning_app/features/home/cubit/states/search_state.dart';
import 'package:event_planning_app/features/home/data/models/event_summary_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;

  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);

    // Trigger initial search
    if (widget.searchQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SearchCubit>().searchEvents(widget.searchQuery);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppString.search,
          style: AppTextStyle.bold20(AppColor.black),
        ),
        actions: [
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.0307,
              vertical: size.height * 0.01,
            ),
            child: CustomTextform(
              controller: _searchController,
              prefixicon: AppIcon.search,
              prefixtext: AppString.search,
              fillColor: AppColor.colorbr9E,
              onChanged: (value) {
                context.read<SearchCubit>().searchEvents(value);
              },
              onFieldSubmitted: (value) {
                context.read<SearchCubit>().searchEvents(value);
              },
            ),
          ),

          // Search results
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return switch (state) {
                  SearchInitial() => _buildInitialView(),
                  SearchLoading() => _buildLoadingView(),
                  SearchLoaded() => _buildResultsView(state),
                  SearchError() => _buildErrorView(state),
                  _ => _buildInitialView(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  // Initial state
  Widget _buildInitialView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppString.starttyping,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Loading state
  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Results loaded
  Widget _buildResultsView(SearchLoaded state) {
    final events = state.events;

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppString.noresult,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 8,
          ),
          child: Text(
            '${events.length} results found for "${state.query}"',
            style: AppTextStyle.medium14(AppColor.colorbr688),
          ),
        ),

        // Results list
        Expanded(
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _SearchResultCard(
                event: event,
                onTap: () {
                  context.push(
                    AppRoutes.eventDetails,
                    extra: {"eventId": event.id},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Error state
  Widget _buildErrorView(SearchError state) {
    return Center(
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
            '❌ ${state.message}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                context
                    .read<SearchCubit>()
                    .searchEvents(_searchController.text);
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Filter bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => _FilterBottomSheet(
        onApplyFilters: (upcomingOnly, popularOnly) {
          context.read<SearchCubit>().searchWithFilters(
                query: _searchController.text,
                upcomingOnly: upcomingOnly,
                popularOnly: popularOnly,
              );
          Navigator.pop(sheetContext);
        },
      ),
    );
  }
}

// ==================== Search Result Card ====================
class _SearchResultCard extends StatelessWidget {
  final EventSummaryModel event;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: size.width * 0.02,
          horizontal: size.width * 0.04,
        ),
        padding: EdgeInsets.all(size.width * 0.02),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: event.imageUrl ?? '',
                width: size.width * 0.25,
                height: size.height * 0.1,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.event, size: 30),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.0256),

            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTextStyle.bold14(AppColor.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.005),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: size.width * 0.0102),
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

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Filter Bottom Sheet ====================
class _FilterBottomSheet extends StatefulWidget {
  final Function(bool upcomingOnly, bool popularOnly) onApplyFilters;

  const _FilterBottomSheet({required this.onApplyFilters});

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  bool _upcomingOnly = false;
  bool _popularOnly = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppTextStyle.bold20(AppColor.black),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Upcoming filter
          SwitchListTile(
            title: const Text('Upcoming Events Only'),
            subtitle: const Text('Show only future events'),
            value: _upcomingOnly,
            onChanged: (value) {
              setState(() => _upcomingOnly = value);
            },
          ),

          // Popular filter
          SwitchListTile(
            title: const Text('Popular Events Only'),
            subtitle: const Text('Show only popular events'),
            value: _popularOnly,
            onChanged: (value) {
              setState(() => _popularOnly = value);
            },
          ),

          const SizedBox(height: 16),

          // Apply button
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _upcomingOnly = false;
                      _popularOnly = false;
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(_upcomingOnly, _popularOnly);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
