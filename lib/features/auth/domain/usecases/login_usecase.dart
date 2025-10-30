import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/auth/domain/entities/user_entity.dart';
import 'package:event_planning_app/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];

  Map<String, String> validate() {
    final errors = <String, String>{};

    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!_isValidEmail(email)) {
      errors['email'] = 'Invalid email format';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }

    return errors;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool get isValid => validate().isEmpty;
}

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    // Validate
    final errors = params.validate();
    if (errors.isNotEmpty) {
      return Left(ValidationFailure(errors: errors));
    }

    // Execute
    return await _repository.login(
      email: params.email.trim().toLowerCase(),
      password: params.password,
    );
  }
}