import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/auth/domain/entities/user_entity.dart';
import 'package:event_planning_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  const RegisterParams({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.role = 'ATTENDEE',
  });

  @override
  List<Object?> get props => [username, email, password, confirmPassword, role];

  Map<String, String> validate() {
    final errors = <String, String>{};

    // Username validation
    if (username.trim().isEmpty) {
      errors['username'] = 'Username is required';
    } else if (username.trim().length < 3) {
      errors['username'] = 'Username must be at least 3 characters';
    } else if (username.trim().length > 30) {
      errors['username'] = 'Username must be less than 30 characters';
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      errors['username'] = 'Username can only contain letters, numbers, and underscores';
    }

    // Email validation
    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!_isValidEmail(email)) {
      errors['email'] = 'Invalid email format';
    }

    // Password validation
    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    } else if (password.length > 100) {
      errors['password'] = 'Password is too long';
    }

    // Confirm password validation
    if (confirmPassword.isEmpty) {
      errors['confirmPassword'] = 'Please confirm your password';
    } else if (password != confirmPassword) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    return errors;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get isValid => validate().isEmpty;
}

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    // Validate
    final errors = params.validate();
    if (errors.isNotEmpty) {
      return Left(ValidationFailure(errors: errors));
    }

    // Execute
    return await _repository.register(
      username: params.username.trim(),
      email: params.email.trim().toLowerCase(),
      password: params.password,
      role: params.role,
    );
  }
}