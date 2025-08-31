import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/auth/data/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoadingUsername extends UserState {}

class UserLoadingFacebook extends UserState {}

class UserLoggedIn extends UserState {
  final UserModel user;
  UserLoggedIn(this.user);

  @override
  List<Object?> get props => [user];
}

class UserLoggingOut extends UserState {}

class UserLoggedOut extends UserState {}

class UserError extends UserState {
  final String message;
  UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserLoadingEmail extends UserState {}

class UserEmailSent extends UserState {}

class UserLoadingGoogle extends UserState {}
