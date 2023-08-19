import 'package:chat/feature/chat/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    String? token,
    String? receiverId,
    String? senderId,
    String? message,
    MessageStatus? status,
    String? createdAt,
    String? updatedAt,
  }) : super(
          token: token,
          senderId: senderId,
          receiverId: receiverId,
          message: message,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      token: json['token'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      status: _parseMessageStatus(json['status']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
  factory MessageModel.fromMessage(Message message) {
    return MessageModel(
      token: message.token,
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      status: message.status,
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'status': status?.toString().split('.').last,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static MessageStatus? _parseMessageStatus(String? status) {
    if (status == 'sent') {
      return MessageStatus.sent;
    } else if (status == 'received') {
      return MessageStatus.received;
    }
    // Handle other cases as needed
    return null;
  }
}
