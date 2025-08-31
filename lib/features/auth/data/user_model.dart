class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? profilePicture;
  final bool isFacebook;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.profilePicture,
    this.isFacebook = false,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
    );
  }

  factory UserModel.fromFacebook(Map<String, dynamic> data) {
    return UserModel(
      uid: data['id'] ?? '',
      email: data['email'] ?? '',
      username: data['name'] ?? '',
      profilePicture: data['picture']?['data']?['url'],
      isFacebook: true,
    );
  }
}
