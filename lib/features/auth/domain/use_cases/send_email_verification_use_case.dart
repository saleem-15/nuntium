import 'package:dartz/dartz.dart';
import 'package:nuntium/core/errors/failures.dart';

import '../repositories/auth_repository.dart';

class SendEmailVerificationUseCase {
  final AuthRepository _authRepository;

  SendEmailVerificationUseCase(this._authRepository);

  Future<Either<Failure, void>> call() {
    return _authRepository.sendEmailVerification();
  }
}
