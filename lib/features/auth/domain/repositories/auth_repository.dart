import 'package:dartz/dartz.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Register with email and password
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required String email,
    required String password,
    String role = 'ATTENDEE',
  });

  /// Login with email and password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Login with Google
  Future<Either<Failure, UserEntity>> loginWithGoogle();

  /// Login with Facebook
  Future<Either<Failure, UserEntity>> loginWithFacebook();

  /// Refresh access token
  Future<Either<Failure, String>> refreshToken();

  /// Logout
  Future<Either<Failure, void>> logout();

  /// Get current user from cache
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}