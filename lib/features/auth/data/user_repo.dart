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

  Future<UserModel> updatePassword(
      String oldPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;

      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);
      }

      return loginWithUsernameOrEmail(
          usernameOrEmail: user!.email!, password: newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    }
  }

  // Edit profile: update email and/or username
  // Future<void> editProfile({
  //   String? email,
  //   String? username,
  //   String? currentPassword,
  // }) async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user == null) throw FirebaseFailure("No user logged in");

  //     // 🔹 Re-authenticate if email is being changed
  //     if (email != null && currentPassword != null) {
  //       final credential = EmailAuthProvider.credential(
  //         email: user.email!,
  //         password: currentPassword,
  //       );
  //       await user.reauthenticateWithCredential(credential);

  //       // ✅ Latest method: sends verification to new email
  //       await user.verifyBeforeUpdateEmail(email);

  //       // Optionally update Firestore immediately,
  //       // but Auth email updates only after verification link click
  //       await _firestore
  //           .collection(ApiKeypoint.fireUsersCollection)
  //           .doc(user.uid)
  //           .update({ApiKeypoint.fireEmail: email});
  //     }

  //     // 🔹 Update username in Firestore
  //     if (username != null) {
  //       await _firestore
  //           .collection(ApiKeypoint.fireUsersCollection)
  //           .doc(user.uid)
  //           .update({ApiKeypoint.fireName: username});
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     throw FirebaseFailure.fromAuthException(e);
  //   } on FirebaseException catch (e) {
  //     throw FirebaseFailure.fromFirestoreException(e);
  //   }
  // }

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

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userData = await _helper.getUserData(user.uid);
      return UserModel.fromFirestore(
        data: userData,
        uid: user.uid,
        emailVerified: user.emailVerified,
      );
    } catch (e) {
      return null;
    }
  }

  // Update user profile with optional fields
  Future<UserModel> updateProfile({
    String? username,
    String? email,
    String? about,
    File? profileImage,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw AuthFailure.userNotFound();

      final Map<String, dynamic> updates = {};

      // Upload profile image to Supabase Storage if provided
      if (profileImage != null) {
        final supabase = Supabase.instance.client;
        final fileExtension = profileImage.path.split('.').last;
        final fileName =
            '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final filePath = 'user_images/$fileName';

        // Upload to Supabase Storage bucket 'user_images'
        await supabase.storage.from('user_images').upload(
              filePath,
              profileImage,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: true,
              ),
            );

        // Get public URL of the uploaded image
        final imageUrl =
            supabase.storage.from('user_images').getPublicUrl(filePath);
        updates[FirebaseKeys.fireProfilePicture] = imageUrl;
      }

      // Update username if provided
      if (username != null && username.isNotEmpty) {
        // Check if username already exists
        final query = await _firestore
            .collection(FirebaseKeys.fireUsersCollection)
            .where(FirebaseKeys.fireUsername, isEqualTo: username)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty && query.docs.first.id != user.uid) {
          throw AuthFailure.emailAlreadyInUse();
        }
        updates[FirebaseKeys.fireName] = username;
      }

      // Update about if provided
      if (about != null) {
        updates[FirebaseKeys.fireAbout] = about;
      }

      // Update email if provided (requires re-authentication in the future)
      if (email != null && email.isNotEmpty && email != user.email) {
        updates[FirebaseKeys.fireEmail] = email;
        // Note: Actual email update in Firebase Auth requires re-authentication
        // This only updates Firestore. For full email update, use editProfile method
      }

      // Perform Firestore update
      if (updates.isNotEmpty) {
        await _firestore
            .collection(FirebaseKeys.fireUsersCollection)
            .doc(user.uid)
            .update(updates);
      }

      // Fetch and return updated user data
      final userData = await _helper.getUserData(user.uid);
      return UserModel.fromFirestore(
        data: userData,
        uid: user.uid,
        emailVerified: user.emailVerified,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromException(e);
    } on FirebaseException catch (e) {
      throw FirestoreFailure.fromException(e);
    }
  }
}
