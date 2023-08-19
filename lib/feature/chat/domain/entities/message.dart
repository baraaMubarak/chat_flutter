enum MessageStatus { sent, received, seen }

class Message {
  String? token;
  String? senderId;
  String? receiverId;
  String? message;
  MessageStatus? status;
  String? createdAt;
  String? updatedAt;

  Message({
    this.token,
    this.senderId,
    this.receiverId,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.status,
  });
}
