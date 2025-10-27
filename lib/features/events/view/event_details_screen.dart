import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/events/cubit/cubit/event_cubit.dart';
import 'package:event_planning_app/features/events/cubit/state/event_state.dart';
import 'package:event_planning_app/features/events/view/widgets/event_details_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit(getIt())..getEventById(eventId),
      child: EventDetailsView(eventId: eventId),
    );
  }
}

class EventDetailsView extends StatelessWidget {
  final String eventId;

  const EventDetailsView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          return switch (state) {
            EventInitial() => const _InitialView(),
            EventLoading() => const _LoadingView(),
            EventLoaded() => _LoadedView(state: state, eventId: eventId),
            EventError() =>
              _ErrorView(message: state.message, eventId: eventId),
            _ => const _InitialView(),
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
  final EventLoaded state;
  final String eventId;

  const _LoadedView({required this.state, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<EventCubit>().refreshEvent(eventId);
      },
      child: EventDetailsScreenBody(event: state.event),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final String eventId;

  const _ErrorView({required this.message, required this.eventId});

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
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load event',
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
                context.read<EventCubit>().getEventById(eventId);
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
