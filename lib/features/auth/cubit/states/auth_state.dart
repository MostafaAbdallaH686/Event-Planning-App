import 'package:equatable/equatable.dart';
import 'package:event_planning_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthValidationError extends AuthState {
  final Map<String, String> errors;

  const AuthValidationError(this.errors);

  @override
  List<Object?> get props => [errors];
}

// Password visibility states
class PasswordVisibilityChanged extends AuthState {
  final bool isVisible;

  const PasswordVisibilityChanged(this.isVisible);

  @override
  List<Object?> get props => [isVisible];
}