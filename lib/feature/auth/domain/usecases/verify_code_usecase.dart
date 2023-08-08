import 'package:chat/feature/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/User.dart';

class VerifyCodeUseCase {
  AuthRepository authRepository;

  VerifyCodeUseCase({required this.authRepository});

  Future<Either<Failure, User>> call({required String code}) async {
    return authRepository.verifyCode(code: code);
  }
}
