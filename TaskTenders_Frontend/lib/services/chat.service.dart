import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasktender_frontend/models/chat.model.dart';
import 'package:tasktender_frontend/models/message.model.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';

class ChatService {
  final UserService _userService = locator<UserService>();

  static const String _collectionName = 'chats';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendChatMessage(String chatId, Message message) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final chatRef = _firestore.collection(_collectionName).doc(chatId);
        final messageRef = chatRef.collection('messages').doc();
        message.id = messageRef.id;

        transaction.set(messageRef, message.toJson());

        transaction.update(chatRef, {
          'lastMessage': message.message,
          'lastMessageSenderId': message.senderId,
          'lastMessageTimestamp': message.timestamp,
        });
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Stream of chat messages for a specific job
  Stream<List<Message>> getChatMessages(String chatId) {
    return _firestore
        .collection(_collectionName)
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<Message?>((doc) => Message.fromJson(doc.data()))
            .where((message) => message != null) // Filter out null values
            .map<Message>((message) => message!) // Safely cast to non-nullable
            .toList());
  }

  Stream<List<Chat>> getChats() {
    final userId = _userService.getUserUid();
    final roleCondition =
        _userService.getUserRole() == 'tasker' ? 'taskerId' : 'clientId';
    return _firestore
        .collection(_collectionName)
        .where(roleCondition, isEqualTo: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<Chat?>((doc) => Chat.fromJson(doc.data()))
            .where((chat) => chat != null) // Filter out null values
            .map<Chat>((chat) => chat!) // Safely cast to non-nullable
            .toList());
  }

  Future<Chat?> createChat(String taskerId, String clientId, String taskerName,
      String clientName) async {
    try {
      //check if chat already exists, and if it does, return the chat Id
      final chatSnapshot = await _firestore
          .collection(_collectionName)
          .where('taskerId', isEqualTo: taskerId)
          .where('clientId', isEqualTo: clientId)
          .get();

      if (chatSnapshot.docs.isNotEmpty) {
        return Chat.fromJson(chatSnapshot.docs.first.data());
      }

      final chatRef = _firestore.collection(_collectionName).doc();

      final Chat chat = Chat(
        id: chatRef.id,
        taskerId: taskerId,
        clientId: clientId,
        taskerName: taskerName,
        clientName: clientName,
        lastMessage: '',
        lastMessageSenderId: '',
        lastMessageTimestamp: DateTime.now(),
      );

      await chatRef.set(chat.toJson());

      return chat;
    } catch (e) {
      print('Error creating chat: $e');
      return null;
    }
  }
}
