class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? profilePicture;
  final bool emailVerified;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.profilePicture,
    this.emailVerified = false,
  });

  factory UserModel.fromFirestore(
      {required Map<String, dynamic> data,
      required String uid,
      bool emailVerified = false}) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      emailVerified: emailVerified,
    );
  }

  factory UserModel.fromFacebook({required Map<String, dynamic> data}) {
    return UserModel(
        uid: data['id'] ?? '',
        email: data['email'] ?? '',
        username: data['name'] ?? '',
        profilePicture: data['picture']?['data']?['url'],
        emailVerified: true);
  }

  factory UserModel.fromGoogle(Map<String, dynamic> data) {
    return UserModel(
        uid: data['id'] ?? '',
        email: data['email'] ?? '',
        username: data['name'] ?? '',
        profilePicture: data['photoUrl'],
        emailVerified: true);
  }
}
