import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/auth/data/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

//used in sign in with username (loading)
class UserLoadingUsername extends UserState {}

//used in sign in with facebook (loading)
class UserLoadingFacebook extends UserState {}

//used if the user logged in with username, facebook or google (success)
class UserLoggedIn extends UserState {
  final UserModel user;
  UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

//used in logout (loading)
class UserLoggingOut extends UserState {}

//used in logout (success)
class UserLoggedOut extends UserState {}

//used in user error in all cases
class UserError extends UserState {
  final String message;
  UserError(this.message);

  @override
  List<Object?> get props => [message];
}

//used in reset password (loading)
class UserResettingPassword extends UserState {}

//used in reset password (just know if email sent) (success) => i can't know if the user reset password successfully or not
class UserEmailSent extends UserState {}

//used in login with google (loading)
class UserLoadingGoogle extends UserState {}

//used in sign up (loading)
class UserSigningUp extends UserState {}

//used in sign up (success)
class UserSignedUp extends UserState {
  final UserModel user;
  UserSignedUp(this.user);

  @override
  List<Object?> get props => [user];
}
