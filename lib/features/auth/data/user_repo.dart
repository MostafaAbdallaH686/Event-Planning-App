import 'dart:io';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
import 'package:event_planning_app/core/utils/errors/facebook_login_failure.dart';
import 'package:event_planning_app/core/utils/errors/failures.dart';
import 'package:event_planning_app/core/utils/errors/firestore_failure.dart';
import 'package:event_planning_app/core/utils/errors/google_signin_failure.dart';
import 'package:event_planning_app/core/utils/network/firebase_keys.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/auth/data/user_repo_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'user_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FacebookAuth _facebook = FacebookAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final CacheHelper _cacheHelper = getIt<CacheHelper>();
  final UserRepoHelper _helper = UserRepoHelper();

  Future<UserModel> loginWithUsernameOrEmail({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final email = await _helper.getEmailFromInput(usernameOrEmail);
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user == null) throw AuthFailure.userNotFound();

      final token = await user.getIdToken();
      await _helper.saveAuthData(token, user.emailVerified);

      final userData = await _helper.getUserData(user.uid);
      return UserModel.fromFirestore(
        data: userData,
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

  Future<void> sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }

  Future<UserModel> loginWithFacebook() async {
    try {
      final LoginResult result = await _facebook.login(
        permissions: [FirebaseKeys.fireEmail, FirebaseKeys.firePublicProfile],
      );

      if (result.status != LoginStatus.success) {
        throw FacebookLoginFailure.fromStatus(
          result.status,
          message: result.message,
        );
      }

      final accessToken = result.accessToken;
      if (accessToken == null) {
        throw const FacebookLoginFailure(
          message: 'Failed to get access token',
          code: 'no-access-token',
        );
      }

      final cred = FacebookAuthProvider.credential(accessToken.tokenString);

      return _helper.signInWithCredential(cred, provider: "facebook");
    } on AuthFailure {
      rethrow;
    } on FacebookLoginFailure {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _facebook.logOut();
      await _googleSignIn.signOut();
      await _cacheHelper.clearData();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthFailure.userNotFound();

      await _firestore
          .collection(FirebaseKeys.fireUsersCollection)
          .doc(user.uid)
          .delete();
      await user.delete();
      await _cacheHelper.clearData();
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

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  Future<UserModel> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();

      if (account == null) {
        throw GoogleSignInFailure.cancelled();
      }

      final googleAuth = account.authentication;

      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return _helper.signInWithCredential(cred, provider: "google");
    } on AuthFailure {
      rethrow;
    } on GoogleSignInFailure {
      rethrow;
    } on PlatformException catch (e) {
      throw GoogleSignInFailure(
        message: e.message ?? 'Google sign-in failed',
        code: e.code,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  Future<UserModel> signUpWithUsernameAndEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Check if username exists
      final query = await _firestore
          .collection(FirebaseKeys.fireUsersCollection)
          .where(FirebaseKeys.fireUsername, isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        throw const AuthFailure(
          message: 'Username already taken',
          code: 'username-already-in-use',
        );
      }

      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;
      if (user == null) {
        throw const AuthFailure(
          message: 'Sign up failed',
          code: 'signup-failed',
        );
      }

      await user.sendEmailVerification();

      final token = await user.getIdToken();
      await _helper.saveAuthData(token, user.emailVerified);

      final data = {
        FirebaseKeys.fireId: user.uid,
        FirebaseKeys.fireEmail: email,
        FirebaseKeys.fireName: username,
        FirebaseKeys.fireFollowers: [],
        FirebaseKeys.fireFollowing: [],
        FirebaseKeys.fireProfilePicture: '',
        FirebaseKeys.fireAbout: '',
        FirebaseKeys.fireInterests: [],
        FirebaseKeys.fireCreatedAt: FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(FirebaseKeys.fireUsersCollection)
          .doc(user.uid)
          .set(data, SetOptions(merge: true));

      final createdData = await _helper.getUserData(user.uid);
      return UserModel.fromFirestore(
        data: createdData,
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
}
