import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
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
  CacheHelper cacheHelper = CacheHelper();
  Future<UserModel> loginWithUsernameOrEmail(
      {required String usernameOrEmail, required String password}) async {
    try {
      String email;
      Map<String, dynamic> userData;
      String uid;
      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
      final isEmail = emailRegex.hasMatch(usernameOrEmail);

      if (isEmail) {
        email = usernameOrEmail;

        final query = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        if (query.docs.isEmpty) {
          throw Exception("User data not found");
        }
        userData = query.docs.first.data();
        uid = query.docs.first.id;
      } else {
        // Get user email from Firestore
        final query = await _firestore
            .collection('users')
            .where('username', isEqualTo: usernameOrEmail)
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          throw Exception("Username not found");
        }

        userData = query.docs.first.data();
        uid = query.docs.first.id;
        email = userData['email'];
      }

      // Login with email & password
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user!.reload();

      //save token in cache
      final token = await userCred.user!.getIdToken();

      if (token != null) {
        await cacheHelper.saveData(
          key: SharedPrefereneceKey.accesstoken,
          value: token,
        );
      }
      if (userCred.user!.emailVerified) {
        cacheHelper.saveData(key: SharedPrefereneceKey.isLogin, value: true);
      }

      return UserModel.fromFirestore(
          data: userData,
          uid: uid,
          emailVerified: userCred.user!.emailVerified);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  Future<void> sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }

  Future<UserModel> loginWithFacebook() async {
    final LoginResult result = await _facebook.login(
      permissions: ["email", "public_profile"],
    );

    if (result.status == LoginStatus.success) {
      final accessToken = result.accessToken;

      if (accessToken != null) {
        // sign in with Firebase
        final facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        // save token in cache
        await CacheHelper().saveData(
          key: SharedPrefereneceKey.accesstoken,
          value: accessToken.tokenString,
        );

        // get user from Firebase
        final user = userCredential.user;

        if (user == null) {
          throw Exception("Failed to get Firebase user");
        }
        final userData = await _facebook.getUserData(
          fields: "id,name,email,picture.width(200)",
        );
        return UserModel.fromFacebook(data: userData);
      } else {
        throw Exception("Access token is null");
      }
    } else if (result.status == LoginStatus.cancelled) {
      throw Exception('Facebook login cancelled by user');
    } else {
      throw Exception(result.message ?? 'Facebook login failed');
    }
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

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;

      //save token in cache
      final token = await user!.getIdToken();
      if (userCred.user!.emailVerified) {
        cacheHelper.saveData(key: SharedPrefereneceKey.isLogin, value: true);
      }

      if (token != null) {
        await CacheHelper().saveData(
          key: SharedPrefereneceKey.accesstoken,
          value: token,
        );
      }

      final data = {
        'id': user.uid,
        'email': user.email,
        'name': user.displayName,
        'photoUrl': user.photoURL,
      };

      return UserModel.fromGoogle(data);
    } catch (e) {
      throw Exception('Google sign-in failed: $e ');
    }
  }

  Future<UserModel> signUpWithUsernameAndEmail(
      {required String username,
      required String email,
      required String password}) async {
    try {
      // Check if username exists
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        throw Exception("Username already exists");
      }

      // Create user in Firebase Auth
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user!.sendEmailVerification();

      //save token in cache
      final token = await userCred.user!.getIdToken();

      if (token != null) {
        await CacheHelper().saveData(
          key: SharedPrefereneceKey.accesstoken,
          value: token,
        );
      }

      final uid = userCred.user!.uid;

      // Save user data in Firestore
      final user = UserModel(
        uid: uid,
        email: email,
        username: username,
      );
      //set user data in firebase
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'username': username,
        'profilePicture': null,
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Sign up failed");
    }
  }
}
