import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/failure/firebase_exception.dart';
import 'package:event_planning_app/core/utils/network/api_keypoint.dart';
import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepoHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CacheHelper _cacheHelper = CacheHelper();

  Future<UserModel> signInWithCredential(AuthCredential cred,
      {required String provider}) async {
    try {
      final userCred = await _auth.signInWithCredential(cred);
      final user = userCred.user ?? (throw FirebaseFailure("No user found"));
      final token = await user.getIdToken();
      await saveAuthData(token, user.emailVerified);

      final userDoc =
          _firestore.collection(ApiKeypoint.fireUsersCollection).doc(user.uid);

      final docSnapshot = await userDoc.get();

      final Map<String, dynamic> data = {
        ApiKeypoint.fireId: user.uid,
        ApiKeypoint.fireEmail: user.email,
        ApiKeypoint.fireName: user.displayName,
        ApiKeypoint.fireProfilePicture: user.photoURL,
      };

      if (!docSnapshot.exists) {
        data[ApiKeypoint.fireFollowers] = [];
        data[ApiKeypoint.fireFollowing] = [];
        data[ApiKeypoint.fireInterests] = [];
        data[ApiKeypoint.fireAbout] = '';
        data[ApiKeypoint.fireCreatedAt] = FieldValue.serverTimestamp();
      }

      await userDoc.set(data, SetOptions(merge: true));

      final merged = docSnapshot.data() ?? data;
      return UserModel.fromFirestore(
        data: merged,
        uid: user.uid,
        emailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseFailure.fromFirestoreException(e);
    }
  }

  Future<void> saveAuthData(String? token, bool verified) async {
    if (token != null) {
      await _cacheHelper.saveData(
        key: SharedPrefereneceKey.accesstoken,
        value: token,
      );
    }
    if (verified) {
      await _cacheHelper.saveData(
        key: SharedPrefereneceKey.isLogin,
        value: true,
      );
    }
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(ApiKeypoint.fireUsersCollection)
          .doc(uid)
          .get();
      return doc.data() ?? {};
    } on FirebaseException catch (e) {
      throw FirebaseFailure.fromFirestoreException(e);
    }
  }

  Future<String> getEmailFromInput(String input) async {
    final isEmail = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(input);
    if (isEmail) return input;
    try {
      final query = await _firestore
          .collection(ApiKeypoint.fireUsersCollection)
          .where(ApiKeypoint.fireUsername, isEqualTo: input)
          .limit(1)
          .get();

      if (query.docs.isEmpty) throw FirebaseFailure("Username not found");
      return query.docs.first.data()[ApiKeypoint.fireEmail];
    } on FirebaseException catch (e) {
      throw FirebaseFailure.fromFirestoreException(e);
    }
  }

  Future<void> updateEmail({
    required String currentEmail,
    required String password,
    required String newEmail,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      final cred = EmailAuthProvider.credential(
        email: currentEmail,
        password: password,
      );
      await user.reauthenticateWithCredential(cred);

      await user.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
    } catch (e) {
      throw FirebaseFailure(e.toString());
    }
  }
}
