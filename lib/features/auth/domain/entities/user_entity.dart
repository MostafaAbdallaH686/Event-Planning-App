import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? profilePicture;
  final bool emailVerified;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.profilePicture,
    this.emailVerified = false,
  });

  bool get isOrganizer => role == 'ORGANIZER';
  bool get isAttendee => role == 'ATTENDEE';
  bool get isAdmin => role == 'ADMIN';

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        role,
        profilePicture,
        emailVerified,
      ];
}
