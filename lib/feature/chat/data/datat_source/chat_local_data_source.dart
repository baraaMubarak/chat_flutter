import 'dart:convert';

import 'package:chat/core/shared_pref/shared_pref.dart';
import 'package:chat/feature/chat/data/model/message_model.dart';
import 'package:chat/feature/chat/domain/entities/message.dart';

abstract class ChatLocalDataSource {
  void saveMessage(Message message, String userId);

  void saveListOfMessages(List<Message> messages, String userId);

  // void saveUsers(List<UserModel> users);

  Map<String, List<Message>>? getMessages();

  List<Message> getMessagesByUserId({required String userId});

// List<UserModel> getUsers();
}

class ChatLocalDataSourceImp implements ChatLocalDataSource {
  String MESSAGES_KEY = 'chat_messages';

  // String USERS_KEY = 'chat_users';
  SharedPrefController sharedPrefController = SharedPrefController();

  @override
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
    var allMessages = getMessages();
    if (allMessages != null) {
      if (allMessages[userId] != null) {
        allMessages[userId]!.add(message);
      } else {
        allMessages[userId] = [message];
      }
    } else {
      allMessages = {
        userId: [message]
      };
    }
    // Logger().w(sortChatKeysByLastMessageDate(allMessages));
    // Logger().w(allMessages);
    saveChat(allMessages);
  }

  Map<String, List<Message>> sortChatKeysByLastMessageDate(Map<String, List<Message>> chat) {
    List<String> sortedKeys = chat.keys.toList();

    sortedKeys.sort((a, b) {
      DateTime aLastMessageDate = chat[a]!.isEmpty
          ? DateTime.now()
          : DateTime.parse(
              chat[a]!.last.updatedAt ?? chat[a]!.last.createdAt.toString(),
            );

      DateTime bLastMessageDate = chat[b]!.isEmpty
          ? DateTime.now()
          : DateTime.parse(
              chat[b]!.last.updatedAt ?? chat[b]!.last.createdAt.toString(),
            );

      return bLastMessageDate.compareTo(aLastMessageDate);
    });

    Map<String, List<Message>> sortedChat = {};
    for (String key in sortedKeys) {
      sortedChat[key] = chat[key]!;
    }

    return sortedChat;
  }

  saveChat(Map<String, List<Message>> chat) {
    Map<String, List> messagesMap = {};

    chat.forEach((key, value) {
      List<Map<String, dynamic>> messageList = value.map((msg) => MessageModel.fromMessage(msg).toJson()).toList();
      messagesMap[key] = messageList;
    });
    sharedPrefController.save(
      key: MESSAGES_KEY,
      value: jsonEncode(messagesMap),
    );
    return messagesMap;
  }

  @override
  void saveListOfMessages(List<Message> messages, String userId) {
    var allMessages = getMessages();
    for (int i = 0; i < messages.length; i++) {
      if (allMessages == null) {
        allMessages = {
          userId: [messages[i]],
        };
      } else {
        if (allMessages[userId] == null) {
          allMessages[userId] = [messages[i]];
        } else {
          allMessages[userId]!.add(messages[i]);
        }
      }
    }
    saveChat(allMessages!);
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
