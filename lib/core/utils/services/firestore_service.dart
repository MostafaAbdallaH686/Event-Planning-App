// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //  Add Category
  Future<void> addCategory({
    required String id,
    required String name,
    String? icon,
    String? description,
  }) async {
    await _firestore.collection('categories').doc(id).set({
      'name': name,
      'icon': icon ?? '',
      'description': description ?? '',
    });
  }

  //  Add Banner
  Future<void> addBanner({
    required String id,
    required String imageUrl,
    String? link,
  }) async {
    await _firestore.collection('banners').doc(id).set({
      'imageUrl': imageUrl,
      'link': link ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //  Add Event to a Category
  Future<void> addEvent(String categoryId, EventModel event) async {
    await _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('events')
        .add(event.toMap());
  }

  //  Join Event
  Future<void> joinEvent(
      String categoryId, String eventId, String userId) async {
    final docRef = _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('events')
        .doc(eventId);

    final doc = await docRef.get();
    if (doc.exists) {
      final attendees = List<String>.from(doc.data()?['attendees'] ?? []);

      if (!attendees.contains(userId)) {
        await docRef.update({
          'attendeesCount': FieldValue.increment(1),
          'attendees': FieldValue.arrayUnion([userId]),
        });
      } else {}
    } else {}
  }

  //  Get Categories
  Stream<List<Map<String, dynamic>>> getCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'No name',
          'icon': data['icon'] ?? '',
          'description': data['description'] ?? '',
        };
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getCategoriesOnce() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'No name',
        'icon': data['icon'] ?? '',
        'description': data['description'] ?? '',
      };
    }).toList();
  }

  //  Get Banners
  Stream<List<Map<String, dynamic>>> getBanners() {
    return _firestore
        .collection('banners')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    });
  }

  //  Get Popular Events
  Stream<List<EventModel>> getPopularEvents() {
    return _firestore
        .collectionGroup('events')
        .orderBy('attendeesCount', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromDoc(doc);
      }).toList();
    });
  }

  //  Get Upcoming Events
  Stream<List<EventModel>> getUpcomingEvents() {
    return _firestore
        .collectionGroup('events')
        .where('date', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromDoc(doc);
      }).toList();
    });
  }

  //  Search Events by title
  Future<List<EventModel>> searchEvents(
    String q,
  ) async {
    final start = q;
    final end = '$q\uf8ff';
    final snap = await _firestore
        .collectionGroup('events')
        .where('title', isGreaterThanOrEqualTo: start)
        .where('title', isLessThanOrEqualTo: end)
        .get();
    return snap.docs.map((doc) {
      return EventModel.fromDoc(doc);
    }).toList();
  }

  //  Recommended Events
  Stream<List<EventModel>> getRecommendedEvents(
    List<String> prefs,
  ) {
    if (prefs.isEmpty) {
      return const Stream.empty();
    }
    final safePrefs = prefs.length > 10 ? prefs.sublist(0, 10) : prefs;

    return _firestore
        .collectionGroup('events')
        .where('categoryId', whereIn: safePrefs)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EventModel.fromDoc(doc);
      }).toList();
    });
  }
}
