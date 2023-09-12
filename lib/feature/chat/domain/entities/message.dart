enum MessageStatus { sent, received, seen }

class Message {
  String? token;
  String? timestamp;
  String? senderId;
  String? receiverId;
  String? message;
  MessageStatus? status;
  DateTime? createdAt;
  String? updatedAt;

  Message({
    this.token,
    this.timestamp,
    this.senderId,
    this.receiverId,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.status,
  });
}
