// ignore_for_file: unnecessary_null_comparison, avoid_print
// ToDo :: Mohnd ::change all the static strings with firebaseConstants class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/core/utils/utils/firebase_constants.dart';
import 'package:event_planning_app/features/home/data/catagory_model.dart';

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

  //  Add Interested Event
  Future<void> addInterestedEvent({
    required String userId,
    required String categoryId,
    required String eventId,
    required EventModel event,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('interested')
          .doc(eventId);

      await docRef.set({
        'categoryId': categoryId,
        'title': event.title,
        'description': event.description,
        'date': event.date,
        'location': event.location,
        'imageUrl': event.imageUrl,
        'createdAt': event.createdAt,
        'attendeesCount': event.attendeesCount,
        'organizerId': event.organizerId,
        'isPopular': event.isPopular,
        'tags': event.tags,
        'price': event.price,
        'categoryName': event.categoryName,
      });

      print('✅ Event added to user interested list successfully.');
    } catch (e) {
      print('❌ Error adding interested event: $e');
    }
  }

  // remove Interested Event
  Future<void> removeInterestedEvent({
    required String userId,
    required String eventId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('interested')
          .doc(eventId)
          .delete();

      print('✅ Event removed from interested list.');
    } catch (e) {
      print('❌ Error removing interested event: $e');
    }
  }

  // get all interested
  Stream<List<Map<String, dynamic>>> getUserInterestedEvents(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('interested')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  //  Get Categories
  Stream<List<CategoryModel>> getCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel.fromJson({
          'id': doc.id,
          'name': data['name'] ?? 'No name',
          'icon': data['icon'] ?? '',
          'description': data['description'] ?? '',
        });
      }).toList();
    });
  }

  Future<List<CategoryModel>> getCategoriesOnce() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return CategoryModel.fromJson({
        'id': doc.id,
        'name': data['name'] ?? 'No name',
        'icon': data['icon'] ?? '',
        'description': data['description'] ?? '',
      });
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

  //get events by special category
  Stream<List<EventModel>> getEventsByCategory(String categoryId) {
    return _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('events')
        .snapshots()
        .map(
            (snap) => snap.docs.map((doc) => EventModel.fromDoc(doc)).toList());
  }

  //  Search Events by title
  Stream<List<EventModel>> searchEventsStream(String query) {
    if (query.isEmpty) {
      return const Stream.empty();
    }

    final start = query;
    final end = '$query\uf8ff';

    return FirebaseFirestore.instance
        .collectionGroup('events')
        .where('title', isGreaterThanOrEqualTo: start)
        .where('title', isLessThanOrEqualTo: end)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EventModel.fromDoc(doc)).toList());
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

  Future<void> saveUserInterests(String userId, List<String> interests) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({'interests': interests});
  }

  Future<void> markFirstLogCompleted(String userId) async {
    await _firestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .set({FirebaseConstants.firstlog: true}, SetOptions(merge: true));
  }

  // Get eventby ID
  Stream<EventModel?> getEventById({
    required String categoryId,
    required String eventId,
  }) {
    return _firestore
        .collection('categories')
        .doc(categoryId)
        .collection('events')
        .doc(eventId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return EventModel.fromDoc(doc);
      } else {
        return null;
      }
    });
  }

  //Get Booked Events
  Stream<List<EventModel>> streamBusinessEventsLimit5() {
    try {
      return _firestore
          .collection('categories')
          .doc('business')
          .collection('events')
          .limit(5)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => EventModel.fromDoc(doc)).toList());
    } catch (e) {
      print('❌ Error streaming business events: $e');
      return const Stream.empty();
    }
  }
}
