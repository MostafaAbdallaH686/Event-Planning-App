// import 'dart:io';

// import 'package:event_planning_app/core/utils/errors/auth_failure.dart';
// import 'package:event_planning_app/core/utils/network/firebase_keys.dart';
// import 'package:event_planning_app/features/auth/data/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ProfileRepostiry  { // Update user profile with optional fields
//   Future<UserModel> updateProfile({
//     String? username,
//     String? email,
//     String? about,
//     File? profileImage,
//   }) async {
//     try {
//       final user = _auth.currentUser;
//       if (user == null) throw AuthFailure.userNotFound();

//       final Map<String, dynamic> updates = {};

//       // Upload profile image to Supabase Storage if provided
//       if (profileImage != null) {
//         final supabase = Supabase.instance.client;
//         final fileExtension = profileImage.path.split('.').last;
//         final fileName =
//             '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
//         final filePath = 'user_images/$fileName';

//         // Upload to Supabase Storage bucket 'user_images'
//         await supabase.storage.from('user_images').upload(
//               filePath,
//               profileImage,
//               fileOptions: const FileOptions(
//                 cacheControl: '3600',
//                 upsert: true,
//               ),
//             );

//         // Get public URL of the uploaded image
//         final imageUrl =
//             supabase.storage.from('user_images').getPublicUrl(filePath);
//         updates[FirebaseKeys.fireProfilePicture] = imageUrl;
//       }

//       // Update username if provided
//       if (username != null && username.isNotEmpty) {
//         // Check if username already exists
//         final query = await _firestore
//             .collection(FirebaseKeys.fireUsersCollection)
//             .where(FirebaseKeys.fireUsername, isEqualTo: username)
//             .limit(1)
//             .get();

//         if (query.docs.isNotEmpty && query.docs.first.id != user.uid) {
//           throw AuthFailure.emailAlreadyInUse();
//         }
//         updates[FirebaseKeys.fireName] = username;
//       }

//       // Update about if provided
//       if (about != null) {
//         updates[FirebaseKeys.fireAbout] = about;
//       }

//       // Update email if provided (requires re-authentication in the future)
//       if (email != null && email.isNotEmpty && email != user.email) {
//         updates[FirebaseKeys.fireEmail] = email;
//         // Note: Actual email update in Firebase Auth requires re-authentication
//         // This only updates Firestore. For full email update, use editProfile method
//       }

//       // Perform Firestore update
//       if (updates.isNotEmpty) {
//         await _firestore
//             .collection(FirebaseKeys.fireUsersCollection)
//             .doc(user.uid)
//             .update(updates);
//       }

//       // Fetch and return updated user data
//       final userData = await _helper.getUserData(user.uid);
//       return UserModel.fromFirestore(
//         data: userData,
//         uid: user.uid,
//         emailVerified: user.emailVerified,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw AuthFailure.fromException(e);
//     } on FirebaseException catch (e) {
//       throw FirestoreFailure.fromException(e);
//     }
//   }

// }
