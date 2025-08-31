import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> loginWithUsername(String username, String password) async {
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
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData(
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

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  Future<UserModel?> loginWithGoogle() async {
    try {
      await GoogleSignIn.instance.signOut();
      final account = await GoogleSignIn.instance.authenticate();
      if (account == null) {
        return null;
      }

      final googleAuth = await account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
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
}
