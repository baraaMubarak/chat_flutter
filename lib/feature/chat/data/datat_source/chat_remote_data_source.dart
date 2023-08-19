import 'package:chat/core/api/socket_controller.dart';
import 'package:chat/feature/chat/data/datat_source/chat_local_data_source.dart';
import 'package:chat/feature/chat/data/model/message_model.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Future<List<MessageModel>> getPreviousMessages({required String userId});

  Future<List<Message>> getNotReceivedMessages({required String userId});

  void sendMessage({
    required Message message,
    required void Function(dynamic data) ack,
  });
}

class ChatRemoteDataSourceImp implements ChatRemoteDataSource {
  ChatLocalDataSource chatLocalDataSource = ChatLocalDataSourceImp();
  @override
  Future<List<Message>> getNotReceivedMessages({required String userId}) {
    // TODO: implement getNotReceivedMessages
    throw UnimplementedError();
  }

  @override
  Future<List<MessageModel>> getPreviousMessages({required String userId}) {
    // TODO: implement getPreviousMessages
    throw UnimplementedError();
  }

  @override
  void sendMessage({
    required Message message,
    required void Function(dynamic data) ack,
  }) {
    chatLocalDataSource.saveMessage(message, message.receiverId!);
    SocketController.getInstance().sendMessage(
      message: message,
      ack: ack,
    );
  }
}
