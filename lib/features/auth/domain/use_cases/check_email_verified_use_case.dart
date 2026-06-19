import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase {
  final AuthRepository _authRepository;

  CheckEmailVerifiedUseCase(this._authRepository);

  Future<Either<Failure, bool>> call() {
    return _authRepository.checkEmailVerified();
  }
}
