// class UserModel {
//   final String uid;
//   final String email;
//   final String username;
//   final String? profilePicture;
//   final bool emailVerified;

//   UserModel({
//     required this.uid,
//     required this.email,
//     required this.username,
//     this.profilePicture,
//     this.emailVerified = false,
//   });

//   factory UserModel.fromFirestore(
//       {required Map<String, dynamic> data,
//       required String uid,
//       bool emailVerified = false}) {
//     return UserModel(
//       uid: uid,
//       email: data['email'] ?? '',
//       username: data['username'] ?? '',
//       profilePicture: data['profilePicture'] ?? '',
//       emailVerified: emailVerified,
//     );
//   }

//   factory UserModel.fromFacebook({required Map<String, dynamic> data}) {
//     return UserModel(
//         uid: data['id'] ?? '',
//         email: data['email'] ?? '',
//         username: data['name'] ?? '',
//         profilePicture: data['picture']?['data']?['url'],
//         emailVerified: true);
//   }

//   factory UserModel.fromGoogle({required Map<String, dynamic> data}) {
//     return UserModel(
//         uid: data['id'] ?? '',
//         email: data['email'] ?? '',
//         username: data['name'] ?? '',
//         profilePicture: data['photoUrl'],
//         emailVerified: true);
//   }
// }
import 'package:event_planning_app/core/utils/network/api_keypoint.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? profilePicture;
  final bool emailVerified;
  final String about;
  final int followersCount;
  final int followingCount;
  final List<String> interests;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.profilePicture,
    this.emailVerified = false,
    this.about = '',
    this.followersCount = 0,
    this.followingCount = 0,
    this.interests = const [],
  });

  factory UserModel.fromFirestore({
    required Map<String, dynamic> data,
    required String uid,
    bool emailVerified = false,
  }) {
    final followers = (data['followers'] as List?) ?? const [];
    final following = (data['following'] as List?) ?? const [];
    final interestsRaw = (data['interests'] as List?) ?? const [];
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      username: data['username'] ?? data['name'] ?? '',
      profilePicture: data['profilePicture'] ?? data['photoUrl'],
      emailVerified: emailVerified,
      about: data['about'] ?? '',
      followersCount: followers.length,
      followingCount: following.length,
      interests: interestsRaw.map((e) => e.toString()).toList(),
    );
  }

  factory UserModel.fromFacebook({required Map<String, dynamic> data}) {
    return UserModel.fromFirestore(
      data: {
        ...data,
        ApiKeypoint.fireProfilePicture: data['picture']?['data']?['url'],
      },
      uid: data['id'] ?? '',
      emailVerified: true,
    );
  }

  factory UserModel.fromGoogle({required Map<String, dynamic> data}) {
    return UserModel.fromFirestore(
      data: {
        ...data,
        ApiKeypoint.fireProfilePicture:
            data['photoUrl'] ?? data[ApiKeypoint.fireProfilePicture],
      },
      uid: data[ApiKeypoint.fireId] ?? '',
      emailVerified: true,
    );
  }

  UserModel copyWith({
    String? email,
    String? username,
    String? profilePicture,
    bool? emailVerified,
    String? about,
    int? followersCount,
    int? followingCount,
    List<String>? interests,
  }) =>
      UserModel(
        uid: uid,
        email: email ?? this.email,
        username: username ?? this.username,
        profilePicture: profilePicture ?? this.profilePicture,
        emailVerified: emailVerified ?? this.emailVerified,
        about: about ?? this.about,
        followersCount: followersCount ?? this.followersCount,
        followingCount: followingCount ?? this.followingCount,
        interests: interests ?? this.interests,
      );
}
