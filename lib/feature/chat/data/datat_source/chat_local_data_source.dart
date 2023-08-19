import 'dart:convert';

import 'package:chat/core/shared_pref/shared_pref.dart';
import 'package:chat/feature/chat/data/model/message_model.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';

abstract class ChatLocalDataSource {
  void saveMessage(Message message, String userId);

  // void saveUsers(List<UserModel> users);

  Map<String, List<Message>>? getMessages();

  List<Message> getMessagesByUserId({required String userId});

// List<UserModel> getUsers();
}

class ChatLocalDataSourceImp implements ChatLocalDataSource {
  String MESSAGES_KEY = 'chat_messages';

  // String USERS_KEY = 'chat_users';
  SharedPrefController sharedPrefController = SharedPrefController();

  Map<String, List<Message>>? getMessages() {
    String? stringMessages = sharedPrefController.get(key: MESSAGES_KEY);
    if (stringMessages == null) return null;

    Map<String, dynamic> decodedMap = jsonDecode(stringMessages);
    Map<String, List<Message>> messages = {};

    decodedMap.forEach((key, value) {
      if (value is List) {
        List<Message> messageList = [];
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            messageList.add(MessageModel.fromJson(item));
          }
        }
        messages[key] = messageList;
      }
    });

    return messages;
  }

  // @override
  // List<UserModel> getUsers() {
  //   return (jsonDecode(sharedPrefController.get(key: USERS_KEY)) as List)
  //       .map(
  //         (e) => UserModel.fromJson(e),
  //       )
  //       .toList();
  // }

  @override
  void saveMessage(Message message, String userId) {
    List<Message> messages = getMessagesByUserId(userId: userId);
    messages.add(message);
    Map<String, dynamic> messagesMap = {
      userId: messages.map((msg) => MessageModel.fromMessage(msg).toJson()).toList(),
    };
    sharedPrefController.save(
      key: MESSAGES_KEY,
      value: jsonEncode(messagesMap),
    );
  }

  @override
  List<Message> getMessagesByUserId({required String userId}) {
    if (getMessages() != null) {
      return getMessages()![userId] ?? [];
    }
    return [];
  }

// @override
// void saveUsers(List<UserModel> users) {
//   sharedPrefController.save(key: MESSAGES_KEY, value: jsonEncode(users));
// }
}
