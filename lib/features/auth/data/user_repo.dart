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

//   Future<UserModel> loginWithGoogle() async {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final GoogleSignInAccount? account = await googleSignIn.signIn();

//   if (account == null) {
//     throw Exception("Google sign-in aborted");
//   }

//   final GoogleSignInAuthentication auth = await account.authentication;

//   final credential = GoogleAuthProvider.credential(
//     accessToken: auth.accessToken,
//     idToken: auth.idToken,
//   );

//   UserCredential userCredential = await _auth.signInWithCredential(credential);
//   final user = userCredential.user;

//   if (user == null) throw Exception("Google sign-in failed");

//   return UserModel.fromGoogle({
//     'id': user.uid,
//     'email': user.email,
//     'name': user.displayName,
//     'photoUrl': user.photoURL,
//   });
// }

  // Future<UserModel?> loginWithGoogle() async {
  //   final firebaseAuth = FirebaseAuth.instance;
  //   final googleSignIn = GoogleSignIn();
  //   try {
  //     await googleSignIn.initialize();
  //     final account = await googleSignIn.authenticate();

  //     if (account != account) {
  //       final auth = account.authentication;
  //       final cred = GoogleAuthProvider.credential(
  //         idToken: auth.idToken,
  //       );
  //       return await firebaseAuth.signInWithCredential(cred);
  //     }

  //     return null;
  //   } catch (e) {
  //     throw Exception('Facebook sign-in failed $e');
  //   }
  // }

  // Future<UserCredential?> loginWithGoogle() async {
  //   try {
  //     // ابدأ تدفّق تسجيل الدخول (يتطلب أن تكون قد استدعيت initialize مرة واحدة مسبقًا)
  //     final GoogleSignInAccount? account =
  //         await GoogleSignIn.instance.authenticate();
  //     if (account == null) return null; // المستخدم أغلق أو ألغى العملية

  //     // الحصول على رمز الهوية (idToken) - لا حاجة لـ await في v7
  //     final googleAuth = account.authentication; // يحتوي على idToken فقط في v7

  //     // إنشاء الاعتماد وتمريره إلى Firebase
  //     final credential =
  //         GoogleAuthProvider.credential(idToken: googleAuth.idToken);
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } on GoogleSignInException catch (e) {
  //     // أخطاء google_sign_in (يمكن فحص e.code لتفاصيل أدق)
  //     throw Exception('Google sign-in failed: ${e.code}');
  //   } catch (e) {
  //     throw Exception('Google sign-in failed: $e');
  //   }
  // }

  Future<UserModel?> loginWithGoogle() async {
    try {
      print('=================================0==============================');
      await GoogleSignIn.instance.signOut();
      final account = await GoogleSignIn.instance.authenticate();
      print('=================================1==============================');
      if (account == null) {
        return null;
      }
      print('=================================2==============================');

      final googleAuth = await account.authentication;
      print('=================================3==============================');

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      print('=================================4==============================');

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCred.user;
      print('=================================5==============================');

      if (user == null) return null;
      final data = {
        'id': user.uid,
        'email': user.email,
        'name': user.displayName,
        'photoUrl': user.photoURL,
      };
      print('=================================6==============================');

      return UserModel.fromGoogle(data);
    } catch (e) {
      print('=================================7==============================');

      throw Exception('Google sign-in failed: $e ');
    }
  }
}
