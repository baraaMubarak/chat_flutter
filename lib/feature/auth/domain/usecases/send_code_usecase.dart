import 'package:chat/feature/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

class SendCodeUseCase {
  AuthRepository authRepository;

  SendCodeUseCase({required this.authRepository});

  Future<Either<Failure, void>> call({required String email}) async {
    return authRepository.sendCode(email: email);
  }
}
