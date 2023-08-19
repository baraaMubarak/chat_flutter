import 'package:chat/core/errors/failures.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';
import 'package:chat/feature/chat/domain/repository/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetPreviousMessagesUseCase {
  ChatRepository chatRepository;

  GetPreviousMessagesUseCase({required this.chatRepository});

  Future<Either<Failure, List<Message>>> call({
    required String userId,
  }) {
    return chatRepository.getPreviousMessages(userId);
  }
}
