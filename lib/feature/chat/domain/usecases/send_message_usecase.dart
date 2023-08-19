import 'package:chat/core/errors/failures.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/domain/repository/chat_repository.dart';
import 'package:dartz/dartz.dart';

class SendMessageUseCase {
  ChatRepository chatRepository;

  SendMessageUseCase({required this.chatRepository});

  Future<Either<Failure, Unit>> call({
    required Message message,
    required void Function(dynamic data) ack,
  }) {
    return chatRepository.sendMessage(
      message: message,
      ack: ack,
    );
  }
}
