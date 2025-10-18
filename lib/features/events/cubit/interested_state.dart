import 'package:event_planning_app/features/events/data/interested_model.dart';

abstract class InterestedState {}

class InterestedInitial extends InterestedState {}

class InterestedLoading extends InterestedState {}

class InterestedLoaded extends InterestedState {
  final List<InterestedEvent> events;
  InterestedLoaded(this.events);

  DateTime _toDate(dynamic v) {
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (v is DateTime) return v.toUtc();
    try {
      if (v is Map && v.containsKey('seconds')) {
        return DateTime.fromMillisecondsSinceEpoch(
          (v['seconds'] as int) * 1000,
          isUtc: true,
        );
      }
      // Try Firestore Timestamp format
      if (v.toString().contains("Timestamp")) {
        final match = RegExp(r'seconds=(\d+)').firstMatch(v.toString());
        if (match != null) {
          return DateTime.fromMillisecondsSinceEpoch(
            int.parse(match.group(1)!) * 1000,
            isUtc: true,
          );
        }
      }
      return DateTime.tryParse(v.toString())?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    }
  }

  List<InterestedEvent> get upcoming {
    final now = DateTime.now().toUtc();
    final list = events.where((e) {
      final d = _toDate(e.date);
      return d.isAfter(now);
    }).toList();
    list.sort((a, b) => _toDate(a.date).compareTo(_toDate(b.date)));
    return list;
  }

  List<InterestedEvent> get past {
    final now = DateTime.now().toUtc();
    final list = events.where((e) {
      final d = _toDate(e.date);
      return d.isBefore(now);
    }).toList();
    list.sort((a, b) => _toDate(b.date).compareTo(_toDate(a.date)));
    return list;
  }
}

class InterestedError extends InterestedState {
  final String message;
  InterestedError(this.message);
}
