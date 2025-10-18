import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:event_planning_app/features/events/data/interested_model.dart';

class InterestedRepository {
  final FirestoreService _firestoreService;

  InterestedRepository(this._firestoreService);

  Stream<List<InterestedEvent>> watchUserInterested(String userId) {
    return _firestoreService
        .getUserInterestedEvents(userId)
        .map((list) => list.map((m) => InterestedEvent.fromMap(m)).toList());
  }
}
