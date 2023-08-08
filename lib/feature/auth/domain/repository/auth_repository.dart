import 'package:chat/core/errors/failures.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({required User user});
  Future<Either<Failure, User>> login({required String email, required String password});
  Future<Either<Failure, Unit>> sendCode({required String email});
  Future<Either<Failure, User>> verifyCode({required String code});
  Future<Either<Failure, User>> resetPassword({required String password});
}
