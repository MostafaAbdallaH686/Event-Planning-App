import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/auth/data/user_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

// Initial state
class UserInitial extends UserState {}

// Loading states
class UserLoadingUsername extends UserState {}

class UserLoadingFacebook extends UserState {}

class UserLoadingGoogle extends UserState {}

class UserSigningUp extends UserState {}

class UserResettingPassword extends UserState {}

class UserLoggingOut extends UserState {}

// Success states
class UserLoggedIn extends UserState {
  final UserModel user;

  const UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class UserSignedUp extends UserState {
  final UserModel user;

  const UserSignedUp(this.user);

  @override
  List<Object?> get props => [user];
}

class UserEmailSent extends UserState {}

class UserLoggedOut extends UserState {}

// UI toggle state
class UserObscureToggled extends UserState {
  final bool obscure;

  const UserObscureToggled(this.obscure);

  @override
  List<Object?> get props => [obscure];
}

// Error state
class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
