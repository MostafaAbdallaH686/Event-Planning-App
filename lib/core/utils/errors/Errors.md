# Error Handling with Failures

## Overview

This project uses a type-safe failure system based on the `Either` pattern from `dartz` package.

## Architecture

```
Failure (abstract)
├── AuthFailure
├── FirestoreFailure
├── GoogleSignInFailure
├── FacebookLoginFailure
├── NetworkFailure
├── CacheFailure
└── UnexpectedFailure
```

## Basic Usage

### 1. Returning Failures from Repositories

```dart
import 'package:dartz/dartz.dart';
import 'package:your_app/core/errors/auth_failure.dart';

class AuthRepository {
  Future<Either<AuthFailure, User>> signIn(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(result.user!);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromException(e));
    }
  }
}
```

### 2. Handling Failures in Cubits/Blocs

```dart
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepo;

  LoginCubit(this._authRepo) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    final result = await _authRepo.signIn(email, password);

    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }
}
```

### 3. Displaying Failures in UI

```dart
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginError) {
      AppToast.error(state.message);
    }
  },
  child: LoginForm(),
)
```

## Creating Custom Failures

```dart
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });

  factory ValidationFailure.invalidEmail() => const ValidationFailure(
        message: 'Please enter a valid email',
        code: 'invalid-email',
      );

  factory ValidationFailure.shortPassword() => const ValidationFailure(
        message: 'Password must be at least 6 characters',
        code: 'short-password',
      );
}
```

## Programmatic Error Handling

Use error codes for conditional logic:

```dart
final result = await authRepo.signIn(email, password);

result.fold(
  (failure) {
    if (failure.code == 'wrong-password') {
      // Show "Forgot Password?" link
    } else if (failure.code == 'user-not-found') {
      // Suggest sign up
    } else {
      // Generic error
    }
  },
  (user) => // Success
);
```

## Testing Failures

```dart
test('login with wrong password returns AuthFailure', () async {
  // Arrange
  when(() => mockAuth.signInWithEmailAndPassword(
    email: any(named: 'email'),
    password: any(named: 'password'),
  )).thenThrow(
    FirebaseAuthException(code: 'wrong-password'),
  );

  // Act
  final result = await authRepo.signIn('test@test.com', 'wrong');

  // Assert
  expect(result.isLeft(), true);
  result.fold(
    (failure) {
      expect(failure, isA<AuthFailure>());
      expect(failure.code, 'wrong-password');
      expect(failure.message, 'Incorrect password provided.');
    },
    (_) => fail('Should return failure'),
  );
});
```

## Best Practices

1. **Always use specific failure types**
   ```dart
   ✅ return Left(AuthFailure.invalidEmail());
   ❌ return Left(Failure('Invalid email'));
   ```

2. **Preserve error codes**
   ```dart
   ✅ AuthFailure.fromException(e)  // Preserves code
   ❌ AuthFailure(message: e.message)  // Loses code
   ```

3. **Handle all failure types**
   ```dart
   result.fold(
     (failure) => switch (failure) {
       AuthFailure() => handleAuthError(failure),
       NetworkFailure() => handleNetworkError(failure),
       _ => handleGenericError(failure),
     },
     (data) => handleSuccess(data),
   );
   ```

4. **Test failure scenarios**
   ```dart
   test('handles all auth error codes', () {
     final codes = [
       'invalid-email',
       'user-not-found',
       'wrong-password',
     ];

     for (final code in codes) {
       final failure = AuthFailure.fromException(
         FirebaseAuthException(code: code),
       );
       expect(failure.code, code);
     }
   });
   ```

## Common Patterns

### Repository Pattern
```dart
abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Unit>> createTask(Task task);
  Future<Either<Failure, Unit>> deleteTask(String id);
}
```

### UseCase Pattern
```dart
class GetTasksUseCase {
  final TaskRepository _repo;

  GetTasksUseCase(this._repo);

  Future<Either<Failure, List<Task>>> call() {
    return _repo.getTasks();
  }
}
```