import 'dart:async';

import 'package:chat/core/api/socket_controller.dart';
import 'package:chat/feature/chat/data/datat_source/chat_local_data_source.dart';
import 'package:chat/feature/chat/data/model/message_model.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';

abstract class ChatRemoteDataSource {
  Future<void> getPreviousMessagesBySocket({required String userId});

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
  Future<void> getPreviousMessagesBySocket({required String userId}) async {
    final completer = Completer<dynamic>();
    await SocketController.getInstance().getPreviousMessages(
      userId: userId,
      ack: (data) {
        if (data != null) {
          // Logger().w(data);
          List<MessageModel> messages = (data as List).map((e) => MessageModel.fromJson(e)).toList();
          chatLocalDataSource.saveListOfMessages(messages, userId);
          completer.complete(data);
        } else {
          completer.complete({});
        }
      },
    );
    try {
      await completer.future;
    } catch (error) {
      throw Exception();
    }
  }

  @override
  void sendMessage({
    required Message message,
    required void Function(dynamic data) ack,
  }) {
    message.createdAt = DateTime.now();
    // message.timestamp = DateTime.now().timeZoneName;
    chatLocalDataSource.saveMessage(message, message.receiverId!);
    SocketController.getInstance().sendMessage(
      message: message,
      ack: ack,
    );
  }
}
