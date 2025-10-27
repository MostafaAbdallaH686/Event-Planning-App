import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/events/cubit/events_cubit.dart';
import 'package:event_planning_app/features/events/data/events_repository.dart';
import 'package:event_planning_app/features/events/view/widgets/create_event_screen_body.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateEventCubit(getIt<CreateEventRepository>()),
      child: const CreateEventScreenBody(),
    );
  }
}
