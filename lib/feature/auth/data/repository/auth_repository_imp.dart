import 'package:chat/core/errors/exceptions.dart';
import 'package:chat/core/errors/failures.dart';
import 'package:chat/core/network/network_info.dart';
import 'package:chat/feature/auth/data/data_source/auth_local_data_source.dart';
import 'package:chat/feature/auth/data/data_source/auth_remote_data_source.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';
import 'package:chat/feature/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImp implements AuthRepository {
  AuthRemoteDataSource authRemoteDataSource;
  AuthLocalDataSource authLocalDataSource;
  NetworkInfo networkInfo;

  AuthRepositoryImp({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    return await bodiesWithoutSendCode(() => authRemoteDataSource.login(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> register({required User user}) async {
    return await bodiesWithoutSendCode(() => authRemoteDataSource.register(user: user));
  }

  @override
  Future<Either<Failure, User>> resetPassword({required String password}) async {
    return await bodiesWithoutSendCode(() => authRemoteDataSource.resetPassword(password: password));
  }

  @override
  Future<Either<Failure, Unit>> sendCode({required String email}) async {
    try {
      await authRemoteDataSource.sendCode(email: email);
      return const Right(unit);
    } on OfflineException {
      return Left(OfflineFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on EmailIsNotVerifiedException {
      return Left(EmailIsNotVerifiedFailure());
    } catch (e) {
      return Left(UnexpectedFailure(error: e));
    }
  }

  @override
  Future<Either<Failure, User>> verifyCode({required String code}) async {
    return await bodiesWithoutSendCode(() => authRemoteDataSource.verifyCode(code: code));
  }

  Future<Either<Failure, User>> bodiesWithoutSendCode(Future<User> Function() cb) async {
    try {
      return Right(await cb());
    } on OfflineException {
      return Left(OfflineFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on EmailIsNotVerifiedException {
      return Left(EmailIsNotVerifiedFailure());
    } catch (e) {
      return Left(UnexpectedFailure(error: e));
    }
  }
}
