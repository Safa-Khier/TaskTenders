import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String id;
  String taskerId;
  String clientId;
  String taskerName;
  String clientName;
  String lastMessage;
  String lastMessageSenderId;
  DateTime lastMessageTimestamp;

  Chat({
    required this.id,
    required this.taskerId,
    required this.clientId,
    required this.taskerName,
    required this.clientName,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageTimestamp,
  });

  toJson() {
    return {
      'id': id,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'taskerId': taskerId,
      'clientId': clientId,
      'taskerName': taskerName,
      'clientName': clientName,
      'lastMessageTimestamp': lastMessageTimestamp,
    };
  }

  static Chat fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      taskerId: json['taskerId'],
      clientId: json['clientId'],
      taskerName: json['taskerName'],
      clientName: json['clientName'],
      lastMessage: json['lastMessage'],
      lastMessageSenderId: json['lastMessageSenderId'],
      lastMessageTimestamp:
          (json['lastMessageTimestamp'] as Timestamp).toDate(),
    );
  }
}
