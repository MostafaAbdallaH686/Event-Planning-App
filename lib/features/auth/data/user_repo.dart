import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'user_model.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> loginWithUsername(String username, String password) async {
    try {
      // 1. Get user email from Firestore
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      print("======================username: $username====================");
      print(
          "======================query: ${query.docs.first.data()}====================");

      if (query.docs.isEmpty) {
        throw Exception("Username not found");
      }

      final data = query.docs.first.data();
      final uid = query.docs.first.id;
      final email = data['email'];
      print('======================email: $email====================');

      // 2. Login with email & password
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('======================uid: $uid====================');
      print('======================result: $result====================');

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
}
