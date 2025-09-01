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

  Future<UserModel> loginWithUsername(
      {required String username, required String password}) async {
    try {
      // Get user email from Firestore
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception("Username not found");
      }

      final data = query.docs.first.data();
      final uid = query.docs.first.id;
      final email = data['email'];

      // Login with email & password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return UserModel.fromFirestore(data, uid);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Login failed");
    }
  }

  Future<UserModel> loginWithFacebook() async {
    final LoginResult result = await _facebook.login(
      permissions: ['public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final userData = await _facebook.getUserData(
        fields: "id,name,email,picture.width(200)",
      );
      return UserModel.fromFacebook(userData);
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
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
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

      if (user == null) return null;
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
