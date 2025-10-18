import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
import 'package:event_planning_app/core/utils/errors/failures.dart';
import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
import 'package:event_planning_app/core/utils/model/event_model.dart';
import 'package:event_planning_app/features/events/data/events_model.dart';
import 'package:event_planning_app/features/events/data/events_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRepositoryImpl implements EventRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final SupabaseClient _supabase;

  EventRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    SupabaseClient? supabase,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<EventModel> createEvent({
    required CreateEventInput input,
    File? imageFile,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const AuthFailure(
            message: 'Not signed in', code: 'not-signed-in');
      }

      // Prepare an ID first so we can reuse it for both collections
      final globalDoc = _firestore.collection('events').doc();
      final eventId = globalDoc.id;

      // Upload image to Supabase (optional)
      String imageUrl = '';
      if (imageFile != null) {
        final ext = imageFile.path.split('.').last;
        final filePath =
            'event_images/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.$ext';
        await _supabase.storage.from('event_images').upload(
              filePath,
              imageFile,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );
        imageUrl =
            _supabase.storage.from('event_images').getPublicUrl(filePath);
      }

      final event = EventModel(
        id: eventId,
        title: input.title,
        description: input.description,
        categoryId: input.categoryId,
        categoryName: input.categoryName,
        location: input.location,
        date: input.date,
        createdAt: DateTime.now(),
        organizerId: user.uid,
        imageUrl: imageUrl,
        attendeesCount: 0,
        isPopular: false,
        tags: input.tags,
        price: input.price,
      );

      final data = event.toMap()
        ..['createdAt'] = FieldValue.serverTimestamp()
        ..['organizerId'] = user.uid // ensure organizerId is consistent
        ..['id'] = eventId; // optional: can be helpful for client reads

      final userEventsDoc = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('events')
          .doc(eventId);

      final batch = _firestore.batch();
      batch.set(globalDoc, data, SetOptions(merge: true));
      batch.set(userEventsDoc, data, SetOptions(merge: true));
      await batch.commit();

      return event;
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }
}
