import 'package:dartz/dartz.dart';
import 'package:event_planning_app/core/utils/errors/errors/exceptions.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:event_planning_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:event_planning_app/features/auth/domain/entities/user_entity.dart';
import 'package:event_planning_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, UserEntity>> register({
    required String username,
    required String email,
    required String password,
    String role = 'ATTENDEE',
  }) async {
    try {
      // Step 1: Register (only returns user, no tokens)
      final user = await _remoteDataSource.register(
        username: username,
        email: email,
        password: password,
        role: role,
      );

      print('✅ Registration successful: ${user.username}');
      print('🔄 Auto-logging in...');

      // Step 2: Auto-login to get tokens
      final authResponse = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Step 3: Cache tokens and user
      await _localDataSource.cacheTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      await _localDataSource.cacheUser(authResponse.user);

      return Right(authResponse.user);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Cache tokens and user
      await _localDataSource.cacheTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      await _localDataSource.cacheUser(authResponse.user);

      return Right(authResponse.user);
    } on CustomDioException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      final authResponse = await _remoteDataSource.loginWithGoogle();

      // Cache tokens and user
      await _localDataSource.cacheTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      await _localDataSource.cacheUser(authResponse.user);

      return Right(authResponse.user);
    } on CustomDioException catch (e) {
      if (e.code == 'sign-in-cancelled') {
        return const Left(AuthFailure(
          message: 'Sign in cancelled',
          code: 'cancelled',
        ));
      }
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithFacebook() async {
    try {
      final authResponse = await _remoteDataSource.loginWithFacebook();

      // Cache tokens and user
      await _localDataSource.cacheTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      await _localDataSource.cacheUser(authResponse.user);

      return Right(authResponse.user);
    } on CustomDioException catch (e) {
      if (e.code == 'facebook-login-failed') {
        return const Left(AuthFailure(
          message: 'Facebook login cancelled or failed',
          code: 'cancelled',
        ));
      }
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final currentRefreshToken = await _localDataSource.getRefreshToken();

      if (currentRefreshToken == null) {
        return const Left(AuthFailure(
          message: 'No refresh token available',
          code: 'no-refresh-token',
        ));
      }

      final newAccessToken = await _remoteDataSource.refreshToken(
        currentRefreshToken,
      );

      // Cache new access token
      await _localDataSource.cacheTokens(
        accessToken: newAccessToken,
        refreshToken: currentRefreshToken,
      );

      return Right(newAccessToken);
    } on CustomDioException catch (e) {
      // Clear cache if refresh token is invalid
      await _localDataSource.clearCache();
      return Left(AuthFailure(
        message: e.message,
        code: e.code ?? 'refresh-failed',
      ));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final accessToken = await _localDataSource.getAccessToken();
    return accessToken != null;
  }
}
