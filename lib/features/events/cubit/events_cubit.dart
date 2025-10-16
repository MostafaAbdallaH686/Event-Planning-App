// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:event_planning_app/features/events/cubit/events_state.dart';
import 'package:event_planning_app/features/events/data/events_repo.dart';

class InterestedCubit extends Cubit<InterestedState> {
  final InterestedRepository _repo;
  StreamSubscription? _sub;

  InterestedCubit(this._repo) : super(InterestedInitial());

  /// Start watching user's interested events
  void watch(String userId) {
    emit(InterestedLoading());
    _sub?.cancel();
    _sub = _repo.watchUserInterested(userId).listen((events) {
      emit(InterestedLoaded(events));
    }, onError: (e) {
      emit(InterestedError(e.toString()));
    });
  }

  /// Stop watching
  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
