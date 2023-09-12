import 'package:chat/core/errors/exceptions.dart';
import 'package:chat/core/errors/failures.dart';
import 'package:chat/feature/chat/data/datat_source/chat_local_data_source.dart';
import 'package:chat/feature/chat/data/datat_source/chat_remote_data_source.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/domain/repository/chat_repository.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImp implements ChatRepository {
  ChatLocalDataSource chatLocalDataSource;
  ChatRemoteDataSource chatRemoteDataSource;

  ChatRepositoryImp({
    required this.chatLocalDataSource,
    required this.chatRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<Message>>> getNotReceivedMessages(String userId) {
    // TODO: implement getNotSeenMessages
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required Message message,
    required void Function(dynamic data) ack,
  }) async {
    return await _validateExceptions(() {
      chatRemoteDataSource.sendMessage(message: message, ack: ack);
      return Future.value(const Right(unit));
    });
  }

  @override
  Future<Either<Failure, Unit>> getPreviousMessages(String userId) async {
    return await _validateExceptions(() async {
      await chatRemoteDataSource.getPreviousMessagesBySocket(userId: userId);
      return Future.value(const Right(unit));
    });
  }

  Future<Either<Failure, Unit>> _validateExceptions(Future<Either<Failure, Unit>> Function() callback) async {
    try {
      return await callback();
    } on OfflineException {
      return Left(OfflineFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on EmailIsNotVerifiedException {
      return Left(EmailIsNotVerifiedFailure());
    }
  }
}
