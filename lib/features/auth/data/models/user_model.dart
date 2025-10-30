import 'package:event_planning_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.role,
    super.profilePicture,
    super.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('📥 Parsing user JSON: $json');

    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      profilePicture: json['profilePicture'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      if (profilePicture != null) 'profilePicture': profilePicture,
      'emailVerified': emailVerified,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? role,
    String? profilePicture,
    bool? emailVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }
}
