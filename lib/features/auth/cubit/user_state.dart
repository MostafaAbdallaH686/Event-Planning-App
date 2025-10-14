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

class UserDeletingAccount extends UserState {}

class UserUpdatingPassword extends UserState {}

class UserUpdatingProfile extends UserState {}

// Success states (carry user data)
abstract class UserDataState extends UserState {
  UserModel get user;
}

class UserLoggedIn extends UserDataState {
  @override
  final UserModel user;

  UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class UserSignedUp extends UserDataState {
  @override
  final UserModel user;

  UserSignedUp(this.user);

  @override
  List<Object?> get props => [user];
}

class UserVerificationSent extends UserState {}

class UserResetPasswordSent extends UserState {}

class UserLoggedOut extends UserState {}

class UserDeletedAccount extends UserState {}

class UserUpdatedPassword extends UserDataState {
  @override
  final UserModel user;
  UserUpdatedPassword(this.user);
  @override
  List<Object?> get props => [user];
}

class UserUpdatedProfile extends UserDataState {
  @override
  final UserModel user;
  UserUpdatedProfile(this.user);
  @override
  List<Object?> get props => [user];
}

// UI toggle state
class UserObscureToggled extends UserState {
  final bool obscure;

  const UserObscureToggled(this.obscure);

  @override
  List<Object?> get props => [obscure];
}

class UserConfirmObscureToggled extends UserState {
  final bool confirmobscure;

  const UserConfirmObscureToggled(this.confirmobscure);

  @override
  List<Object?> get props => [confirmobscure];
}

// Error state
sealed class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserErrorSignUp extends UserError {
  const UserErrorSignUp(super.message);
}

class UserErrorLoginUsername extends UserError {
  const UserErrorLoginUsername(super.message);
}

class UserErrorLoginGoogle extends UserError {
  const UserErrorLoginGoogle(super.message);
}

class UserErrorLoginFacebook extends UserError {
  const UserErrorLoginFacebook(super.message);
}

class UserErrorNotVerified extends UserError {
  const UserErrorNotVerified(super.message);
}

class UserErrorVerificationSent extends UserError {
  const UserErrorVerificationSent(super.message);
}

class UserErrorResetPassword extends UserError {
  const UserErrorResetPassword(super.message);
}

class UserErrorLogout extends UserError {
  const UserErrorLogout(super.message);
}

class UserErrorDeleteAccount extends UserError {
  const UserErrorDeleteAccount(super.message);
}

class UserErrorUpdatePassword extends UserError {
  const UserErrorUpdatePassword(super.message);
}

class UserErrorUpdateProfile extends UserError {
  const UserErrorUpdateProfile(super.message);
}
