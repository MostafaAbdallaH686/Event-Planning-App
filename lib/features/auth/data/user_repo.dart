import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/network/api_keypoint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FacebookAuth _facebook = FacebookAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final CacheHelper _cacheHelper = CacheHelper();

  Future<UserModel> loginWithUsernameOrEmail({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final email = await _getEmailFromInput(usernameOrEmail);
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCred.user ?? (throw Exception("Login failed"));
      final token = await user.getIdToken();

      await _saveAuthData(token, user.emailVerified);

      final userData = await _getUserData(user.uid);
      return UserModel.fromFirestore(
        data: userData,
        uid: user.uid,
        emailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  Future<void> sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }

  Future<UserModel> loginWithFacebook() async {
    final LoginResult result = await _facebook.login(
      permissions: [ApiKeypoint.fireEmail, ApiKeypoint.firePublicProfile],
    );

    if (result.status != LoginStatus.success) {
      throw Exception('Facebook login failed: ${result.message}');
    }

    final cred =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);

    return _signInWithCredential(cred, provider: "facebook");
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "rest password failed");
    }
  }

  Future<UserModel?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final account = await _googleSignIn.authenticate();

      final googleAuth = account.authentication;

      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return _signInWithCredential(cred, provider: "google");
    } catch (e) {
      throw Exception('Google sign-in failed: $e ');
    }
  }

  Future<UserModel> signUpWithUsernameAndEmail(
      {required String username,
      required String email,
      required String password}) async {
    try {
      final query = await _firestore
          .collection(ApiKeypoint.fireUsersCollection)
          .where(ApiKeypoint.fireUsername, isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        throw Exception("Username already exists");
      }

      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user ?? (throw Exception("Sign up failed"));

      await user.sendEmailVerification();

      final token = await user.getIdToken();
      await _saveAuthData(token, user.emailVerified);

      final data = {
        ApiKeypoint.fireId: user.uid,
        ApiKeypoint.fireEmail: email,
        ApiKeypoint.fireUsername: username,
      };
      await _firestore
          .collection(ApiKeypoint.fireUsersCollection)
          .doc(user.uid)
          .set(data, SetOptions(merge: true));

      return UserModel(
        uid: user.uid,
        email: email,
        username: username,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Sign up failed");
    }
  }

  Future<String> _getEmailFromInput(String input) async {
    final isEmail = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(input);
    if (isEmail) return input;

    final query = await _firestore
        .collection(ApiKeypoint.fireUsersCollection)
        .where(ApiKeypoint.fireUsername, isEqualTo: input)
        .limit(1)
        .get();

    if (query.docs.isEmpty) throw Exception("Username not found");
    return query.docs.first.data()[ApiKeypoint.fireEmail];
  }

  Future<void> _saveAuthData(String? token, bool verified) async {
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

  Future<Map<String, dynamic>> _getUserData(String uid) async {
    final doc = await _firestore
        .collection(ApiKeypoint.fireUsersCollection)
        .doc(uid)
        .get();
    return doc.data() ?? {};
  }

  Future<UserModel> _signInWithCredential(AuthCredential cred,
      {required String provider}) async {
    final userCred = await _auth.signInWithCredential(cred);
    final user = userCred.user ?? (throw Exception("No user found"));
    final token = await user.getIdToken();
    await _saveAuthData(token, user.emailVerified);

    final data = {
      ApiKeypoint.fireId: user.uid,
      ApiKeypoint.fireEmail: user.email,
      ApiKeypoint.fireName: user.displayName,
      ApiKeypoint.firePhotoUrl: user.photoURL,
    };
    await _firestore
        .collection(ApiKeypoint.fireUsersCollection)
        .doc(user.uid)
        .set(data, SetOptions(merge: true));

    return provider == "google"
        ? UserModel.fromGoogle(data: data)
        : UserModel.fromFacebook(data: data);
  }
}
