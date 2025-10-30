import 'package:dartz/dartz.dart';
import 'package:event_planning_app/core/utils/errors/errors/failuress.dart';
import 'package:event_planning_app/features/auth/domain/repositories/auth_repository.dart';
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    return await _repository.logout();
  }
}