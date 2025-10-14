// import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
// import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
// import 'package:event_planning_app/core/utils/failure/firebase_exception.dart';
// import 'package:event_planning_app/core/utils/network/api_keypoint.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'user_model.dart';

// class UserRepository {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FacebookAuth _facebook = FacebookAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//   final CacheHelper _cacheHelper = CacheHelper();

//   Future<UserModel> loginWithUsernameOrEmail({
//     required String usernameOrEmail,
//     required String password,
//   }) async {
//     try {
//       final email = await _getEmailFromInput(usernameOrEmail);
//       final userCred = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final user = userCred.user ?? (throw FirebaseFailure("Login failed"));
//       final token = await user.getIdToken();

//       await _saveAuthData(token, user.emailVerified);

//       final userData = await _getUserData(user.uid);
//       return UserModel.fromFirestore(
//         data: userData,
//         uid: user.uid,
//         emailVerified: user.emailVerified,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseFailure.fromAuthException(e);
//     } on FirebaseException catch (e) {
//       throw FirebaseFailure.fromFirestoreException(e);
//     }
//   }

//   Future<void> sendVerificationEmail(User user) async {
//     await user.sendEmailVerification();
//   }

//   Future<UserModel> loginWithFacebook() async {
//     try {
//       final LoginResult result = await _facebook.login(
//         permissions: [ApiKeypoint.fireEmail, ApiKeypoint.firePublicProfile],
//       );

//       if (result.status != LoginStatus.success) {
//         throw FirebaseFailure.fromFacebookLogin(result.status, result.message);
//       }

//       final cred =
//           FacebookAuthProvider.credential(result.accessToken!.tokenString);

//       return _signInWithCredential(cred, provider: "facebook");
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseFailure.fromAuthException(e);
//     }
//   }

//   Future<void> logout() async {
//     await _auth.signOut();
//   }

//   Future<void> resetPassword({required String email}) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseFailure.fromAuthException(e);
//     }
//   }

//   Future<UserModel?> loginWithGoogle() async {
//     try {
//       await _googleSignIn.signOut();
//       final account = await _googleSignIn.authenticate();

//       final googleAuth = account.authentication;

//       final cred = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//       );

//       return _signInWithCredential(cred, provider: "google");
//     } on GoogleSignInException catch (e) {
//       throw FirebaseFailure.fromGoogleSignInException(e);
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseFailure.fromAuthException(e);
//     }
//   }

//   Future<UserModel> signUpWithUsernameAndEmail(
//       {required String username,
//       required String email,
//       required String password}) async {
//     try {
//       final query = await _firestore
//           .collection(ApiKeypoint.fireUsersCollection)
//           .where(ApiKeypoint.fireUsername, isEqualTo: username)
//           .limit(1)
//           .get();

//       if (query.docs.isNotEmpty) {
//         throw FirebaseFailure("Username already exists");
//       }

//       UserCredential userCred = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final user = userCred.user ?? (throw FirebaseFailure("Sign up failed"));

//       await user.sendEmailVerification();

//       final token = await user.getIdToken();
//       await _saveAuthData(token, user.emailVerified);

//       final data = {
//         ApiKeypoint.fireId: user.uid,
//         ApiKeypoint.fireEmail: email,
//         ApiKeypoint.fireUsername: username,
//       };
//       await _firestore
//           .collection(ApiKeypoint.fireUsersCollection)
//           .doc(user.uid)
//           .set(data, SetOptions(merge: true));

//       return UserModel(
//         uid: user.uid,
//         email: email,
//         username: username,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseFailure.fromAuthException(e);
//     } on FirebaseException catch (e) {
//       throw FirebaseFailure.fromFirestoreException(e);
//     }
//   }

//   Future<String> _getEmailFromInput(String input) async {
//     final isEmail = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(input);
//     if (isEmail) return input;
//     try {
//       final query = await _firestore
//           .collection(ApiKeypoint.fireUsersCollection)
//           .where(ApiKeypoint.fireUsername, isEqualTo: input)
//           .limit(1)
//           .get();

//       if (query.docs.isEmpty) throw FirebaseFailure("Username not found");
//       return query.docs.first.data()[ApiKeypoint.fireEmail];
//     } on FirebaseException catch (e) {
//       throw FirebaseFailure.fromFirestoreException(e);
//     }
//   }

//   Future<void> _saveAuthData(String? token, bool verified) async {
//     if (token != null) {
//       await _cacheHelper.saveData(
//         key: SharedPrefereneceKey.accesstoken,
//         value: token,
//       );
//     }
//     if (verified) {
//       await _cacheHelper.saveData(
//         key: SharedPrefereneceKey.isLogin,
//         value: true,
//       );
//     }
//   }

//   Future<Map<String, dynamic>> _getUserData(String uid) async {
//     try {
//       final doc = await _firestore
//           .collection(ApiKeypoint.fireUsersCollection)
//           .doc(uid)
//           .get();
//       return doc.data() ?? {};
//     } on FirebaseException catch (e) {
//       throw FirebaseFailure.fromFirestoreException(e);
//     }
//   }

//   Future<UserModel> _signInWithCredential(AuthCredential cred,
//       {required String provider}) async {
//     try {
//       final userCred = await _auth.signInWithCredential(cred);
//       final user = userCred.user ?? (throw FirebaseFailure("No user found"));
//       final token = await user.getIdToken();
//       await _saveAuthData(token, user.emailVerified);

//       final data = {
//         ApiKeypoint.fireId: user.uid,
//         ApiKeypoint.fireEmail: user.email,
//         ApiKeypoint.fireName: user.displayName,
//         ApiKeypoint.firePhotoUrl: user.photoURL,
//       };
//       await _firestore
//           .collection(ApiKeypoint.fireUsersCollection)
//           .doc(user.uid)
//           .set(data, SetOptions(merge: true));

//       return provider == "google"
//           ? UserModel.fromGoogle(data: data)
//           : UserModel.fromFacebook(data: data);
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseFailure.fromAuthException(e);
//     } on FirebaseException catch (e) {
//       throw FirebaseFailure.fromFirestoreException(e);
//     }
//   }
// }

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/failure/firebase_exception.dart';
import 'package:event_planning_app/core/utils/network/api_keypoint.dart';
import 'package:event_planning_app/features/auth/data/user_repo_helper.dart';
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
      final user = userCred.user ?? (throw FirebaseFailure("Login failed"));
      final token = await user.getIdToken();

      await _helper.saveAuthData(token, user.emailVerified);

      final userData = await _helper.getUserData(user.uid);
      return UserModel.fromFirestore(
          data: userData, uid: user.uid, emailVerified: user.emailVerified);
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseFailure.fromFirestoreException(e);
    }
  }

  Future<void> sendVerificationEmail(User user) async {
    await user.sendEmailVerification();
  }

  Future<UserModel> loginWithFacebook() async {
    try {
      final LoginResult result = await _facebook.login(
        permissions: [ApiKeypoint.fireEmail, ApiKeypoint.firePublicProfile],
      );

      if (result.status != LoginStatus.success) {
        throw FirebaseFailure.fromFacebookLogin(result.status, result.message);
      }

      final cred =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);

      return _helper.signInWithCredential(cred, provider: "facebook");
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _facebook.logOut();
      await _googleSignIn.signOut();
      await _cacheHelper.clearData();
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _firestore
          .collection(ApiKeypoint.fireUsersCollection)
          .doc(_auth.currentUser!.uid)
          .delete();
      await _auth.currentUser!.delete();
      await _cacheHelper.clearData();
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseFailure.fromFirestoreException(e);
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
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
      throw FirebaseFailure.fromAuthException(e);
    }
  }
  //todo edit profile mohammed don't touch please
  // Future<void> editProfile({String? email , String? username}) async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       _helper.updateEmail(currentEmail: email, password: password, newEmail: newEmail);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     throw FirebaseFailure.fromAuthException(e);
  //   }
  // }

  Future<UserModel?> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final account = await _googleSignIn.authenticate();

      final googleAuth = account.authentication;

      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return _helper.signInWithCredential(cred, provider: "google");
    } on GoogleSignInException catch (e) {
      throw FirebaseFailure.fromGoogleSignInException(e);
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
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
        throw FirebaseFailure("Username already exists");
      }

      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user ?? (throw FirebaseFailure("Sign up failed"));

      await user.sendEmailVerification();

      final token = await user.getIdToken();
      await _helper.saveAuthData(token, user.emailVerified);

      final data = {
        ApiKeypoint.fireId: user.uid,
        ApiKeypoint.fireEmail: email,
        ApiKeypoint.fireName: username,
        ApiKeypoint.fireFollowers: [],
        ApiKeypoint.fireFollowing: [],
        ApiKeypoint.fireProfilePicture: '',
        ApiKeypoint.fireAbout: '',
        ApiKeypoint.fireInterests: [],
        ApiKeypoint.fireCreatedAt: FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection(ApiKeypoint.fireUsersCollection)
          .doc(user.uid)
          .set(data, SetOptions(merge: true));

      final createdData = await _helper.getUserData(user.uid);
      return UserModel.fromFirestore(
          data: createdData, uid: user.uid, emailVerified: user.emailVerified);
    } on FirebaseAuthException catch (e) {
      throw FirebaseFailure.fromAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseFailure.fromFirestoreException(e);
    }
  }
}
