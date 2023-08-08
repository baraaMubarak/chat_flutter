import 'package:chat/feature/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/User.dart';

class ResetPasswordUseCase {
  AuthRepository authRepository;

  ResetPasswordUseCase({required this.authRepository});

  Future<Either<Failure, User>> call({required String password}) async {
    return authRepository.resetPassword(password: password);
  }
}
