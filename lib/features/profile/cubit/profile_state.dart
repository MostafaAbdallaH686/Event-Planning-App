import 'package:equatable/equatable.dart';
import 'package:event_planning_app/core/utils/model/user_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ProfileInitial extends ProfileState {}

// Loading states
class ProfileLoading extends ProfileState {}

class UserLoggingOut extends ProfileState {}

class UserDeletingAccount extends ProfileState {}

class UserUpdatingProfile extends ProfileState {}

// Success states (carry user data)
abstract class ProfileDataState extends ProfileState {
  UserModel get user;
}

class ProfileLoaded extends ProfileState {
  final String username;
  final String email;

  const ProfileLoaded({required this.username, required this.email});

  @override
  List<Object?> get props => [username, email];
}

class UserLoggedIn extends ProfileDataState {
  @override
  final UserModel user;

  UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class UserVerificationSent extends ProfileState {}

class UserLoggedOut extends ProfileState {}

class UserDeletedAccount extends ProfileState {}

class UserUpdatedProfile extends ProfileDataState {
  @override
  final UserModel user;
  UserUpdatedProfile(this.user);
  @override
  List<Object?> get props => [user];
}

// Error states
sealed class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserErrorLoginUsername extends ProfileError {
  const UserErrorLoginUsername(super.message);
}

class UserErrorVerificationSent extends ProfileError {
  const UserErrorVerificationSent(super.message);
}

class UserErrorLogout extends ProfileError {
  const UserErrorLogout(super.message);
}

class UserErrorDeleteAccount extends ProfileError {
  const UserErrorDeleteAccount(super.message);
}

class UserErrorUpdateProfile extends ProfileError {
  const UserErrorUpdateProfile(super.message);
}
