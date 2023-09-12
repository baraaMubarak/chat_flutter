import 'package:chat/core/errors/failures.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure, Unit>> getPreviousMessages(String userId);

  Future<Either<Failure, List<Message>>> getNotReceivedMessages(String userId);

  Future<Either<Failure, Unit>> sendMessage({
    required Message message,
    required void Function(dynamic data) ack,
  });
}
