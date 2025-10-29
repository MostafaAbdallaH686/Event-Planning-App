import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/features/events/cubit/events_cubit.dart';
import 'package:event_planning_app/features/events/cubit/events_state.dart';

import 'create_event_form.dart';

class CreateEventScreenBody extends StatelessWidget {
  const CreateEventScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateEventCubit, CreateEventState>(
      listener: (context, state) {
        if (state is CreateEventSuccess) {
          AppToast.success('Event created');
          if (!context.mounted) return;
          Navigator.pop(context, state.event);
        } else if (state is CreateEventFailure) {
          AppToast.error(state.message);
        } else if (state is CreateEventValidationError) {
          final first = state.errors.values.isNotEmpty
              ? state.errors.values.first
              : 'Invalid input';
          AppToast.warning(first);
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateEventSubmitting;
        return AbsorbPointer(
          absorbing: isLoading,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Create An Event'),
            ),
            body: const CreateEventForm(),
          ),
        );
      },
    );
  }
}
