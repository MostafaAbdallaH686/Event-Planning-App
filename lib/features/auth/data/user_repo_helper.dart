import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
import 'package:event_planning_app/core/utils/errors/failures.dart';
import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
import 'package:event_planning_app/core/utils/model/user_model.dart';
import 'package:event_planning_app/core/utils/network/firebase_keys.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepoHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CacheHelper _cacheHelper = getIt<CacheHelper>();

  Future<UserModel> signInWithCredential(
    AuthCredential cred, {
    required String provider,
  }) async {
    try {
      final userCred = await _auth.signInWithCredential(cred);
      final user = userCred.user;

      if (user == null) throw AuthFailure.userNotFound();

      final token = await user.getIdToken();
      await saveAuthData(token, user.emailVerified);

      final userDoc =
          _firestore.collection(FirebaseKeys.fireUsersCollection).doc(user.uid);

      final docSnapshot = await userDoc.get();

      final Map<String, dynamic> data = {
        FirebaseKeys.fireId: user.uid,
        FirebaseKeys.fireEmail: user.email,
        FirebaseKeys.fireName: user.displayName,
        FirebaseKeys.fireProfilePicture: user.photoURL,
      };

      if (!docSnapshot.exists) {
        data[FirebaseKeys.fireFollowers] = [];
        data[FirebaseKeys.fireFollowing] = [];
        data[FirebaseKeys.fireInterests] = [];
        data[FirebaseKeys.fireAbout] = '';
        data[FirebaseKeys.fireCreatedAt] = FieldValue.serverTimestamp();
      }

      await userDoc.set(data, SetOptions(merge: true));

      final merged = {...?docSnapshot.data(), ...data};
      return UserModel.fromFirestore(
        data: merged,
        uid: user.uid,
        emailVerified: user.emailVerified,
      );
    } on AuthFailure {
      rethrow;
    } on FirestoreFailure {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  Future<void> saveAuthData(String? token, bool verified) async {
    if (token != null) {
      await _cacheHelper.saveData(
        key: SharedPrefereneceKey.accesstoken,
        value: token,
      );
    }
    if (verified) {}
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirebaseKeys.fireUsersCollection)
          .doc(uid)
          .get();
      return doc.data() ?? {};
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  Future<String> getEmailFromInput(String input) async {
    final isEmail = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(input);
    if (isEmail) return input;

    try {
      final query = await _firestore
          .collection(FirebaseKeys.fireUsersCollection)
          .where(FirebaseKeys.fireUsername, isEqualTo: input)
          .limit(1)
          .get();

      if (query.docs.isEmpty) throw AuthFailure.userNotFound();
      return query.docs.first.data()[FirebaseKeys.fireEmail] as String;
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  Future<void> updateEmail({
    required String currentEmail,
    required String password,
    required String newEmail,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw AuthFailure.userNotFound();

      final cred = EmailAuthProvider.credential(
        email: currentEmail,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);
      await user.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }
}
