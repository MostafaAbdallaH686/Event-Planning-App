import 'package:dartz/dartz.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/auth/domain/entities/user_entity.dart';
import 'package:event_planning_app/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, UserEntity?>> call() async {
    return await _repository.getCurrentUser();
  }
}