import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/auth/cubit/states/auth_state.dart';
import 'package:event_planning_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/login_with_facebook_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LoginWithGoogleUseCase _loginWithGoogleUseCase;
  final LoginWithFacebookUseCase _loginWithFacebookUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LoginWithGoogleUseCase loginWithGoogleUseCase,
    required LoginWithFacebookUseCase loginWithFacebookUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _loginWithGoogleUseCase = loginWithGoogleUseCase,
        _loginWithFacebookUseCase = loginWithFacebookUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(AuthInitial());

  // ==================== Check Auth Status ====================
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) {
        print('No cached user found');
        emit(AuthUnauthenticated());
      },
      (user) {
        if (user != null) {
          print('✅ User authenticated: ${user.username}');
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  // ==================== Login ====================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final params = LoginParams(
      email: email,
      password: password,
    );

    // Client-side validation
    final errors = params.validate();
    if (errors.isNotEmpty) {
      emit(AuthValidationError(errors));
      return;
    }

    emit(AuthLoading());

    final result = await _loginUseCase(params);

    result.fold(
      (failure) {
        print('❌ Login failed: ${failure.message}');
        if (failure is ValidationFailure) {
          emit(AuthValidationError(failure.errors));
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) {
        print('✅ Login successful: ${user.username}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  // ==================== Register ====================
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String role = 'ATTENDEE',
  }) async {
    final params = RegisterParams(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      role: role,
    );

    // Client-side validation
    final errors = params.validate();
    if (errors.isNotEmpty) {
      emit(AuthValidationError(errors));
      return;
    }

    emit(AuthLoading());

    final result = await _registerUseCase(params);

    result.fold(
      (failure) {
        print('❌ Registration failed: ${failure.message}');
        if (failure is ValidationFailure) {
          emit(AuthValidationError(failure.errors));
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) {
        print('✅ Registration successful: ${user.username}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  // ==================== Google Login ====================
  Future<void> loginWithGoogle() async {
    emit(AuthLoading());

    final result = await _loginWithGoogleUseCase();

    result.fold(
      (failure) {
        print('❌ Google login failed: ${failure.message}');
        if (failure.code == 'cancelled') {
          emit(AuthUnauthenticated());
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) {
        print('✅ Google login successful: ${user.username}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  // ==================== Facebook Login ====================
  Future<void> loginWithFacebook() async {
    emit(AuthLoading());

    final result = await _loginWithFacebookUseCase();

    result.fold(
      (failure) {
        print('❌ Facebook login failed: ${failure.message}');
        if (failure.code == 'cancelled') {
          emit(AuthUnauthenticated());
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) {
        print('✅ Facebook login successful: ${user.username}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  // ==================== Logout ====================
  Future<void> logout() async {
    emit(AuthLoading());

    final result = await _logoutUseCase();

    result.fold(
      (failure) {
        print('❌ Logout failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (_) {
        print('✅ Logout successful');
        emit(AuthUnauthenticated());
      },
    );
  }
}
