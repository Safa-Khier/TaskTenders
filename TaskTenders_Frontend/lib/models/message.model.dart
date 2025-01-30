/// Message model
/// * [id]: The message's unique identifier
/// * [senderId]: The message's sender ID
/// * [receiverId]: The message's receiver ID
/// * [message]: The message
/// * [timestamp]: The date the message was sent
class Message {
  String? id;
  String senderName;
  String? senderImageUrl;
  String senderId;
  String receiverId;
  String message;
  DateTime timestamp;

  Message({
    this.id,
    required this.senderName,
    this.senderImageUrl,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderName': senderName,
      'senderImageUrl': senderImageUrl,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderName: json['senderName'] ?? 'Safa Khier',
      senderImageUrl: json['senderImageUrl'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      timestamp: json['timestamp'].toDate(),
    );
  }
}
