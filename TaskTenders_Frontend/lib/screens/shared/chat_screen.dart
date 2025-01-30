import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasktender_frontend/models/chat.model.dart';
import 'package:tasktender_frontend/models/message.model.dart';
import 'package:tasktender_frontend/screens/shared/loading_screen.dart';
import 'package:tasktender_frontend/services/chat.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  final Chat chat;
  final String chatId;

  const ChatScreen(
      {super.key,
      @PathParam('chatId') required this.chatId,
      required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = locator<ChatService>();
  final UserService _userService = locator<UserService>();
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final Message message = Message(
      message: _messageController.text.trim(),
      senderName: _userService.getUserName(),
      senderImageUrl: _userService.getUserImageUrl(),
      senderId: _userService.getUserUid(),
      receiverId: '',
      timestamp: DateTime.now(),
    );

    _messageController.clear();

    _chatService.sendChatMessage(widget.chatId, message);
  }

  @override
  Widget build(BuildContext context) {
    final userName = _userService.getUserRole() == 'tasker'
        ? widget.chat.clientName
        : widget.chat.taskerName;

    return Scaffold(
        appBar: AppBar(
          title: Text(userName),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show more options
              },
            ),
          ],
        ),
        body: SafeArea(
          child: FocusScope(
              node: FocusScopeNode(),
              child: Column(
                children: [
                  Expanded(
                      child: StreamBuilder<List<Message>>(
                    stream: _chatService.getChatMessages(
                        widget.chatId), // Pass the jobId to fetch messages
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingScreen(); // Loading state
                      }

                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}"); // Error state
                      }

                      final messages = snapshot.data ?? [];

                      return ListView.builder(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        reverse: true,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final Message message = messages[index];
                          return Column(children: [
                            ...[
                              if (index == messages.length - 1 ||
                                  message.timestamp.day !=
                                      messages[index + 1].timestamp.day)
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 0.5,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd MMM yyyy')
                                            .format(message.timestamp),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                            height: 0.5,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      ),
                                    ])
                            ],
                            _buildMessageItem(message)
                          ]);
                        },
                      );
                    },
                  )),
                  _buildMessageInput()
                ],
              )),
        ));
  }

  Widget _buildMessageItem(Message message) {
    final bool isMe = message.senderId == _userService.getUserUid();
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context)
                      .extension<CustomThemeExtension>()
                      ?.chatSenderBackground ??
                  const Color(0xFFBBDEFB)
              : Theme.of(context)
                      .extension<CustomThemeExtension>()
                      ?.chatReceiverBackground ??
                  const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    var children = [
      // IconButton(
      //   icon: const Icon(Icons.attach_file),
      //   onPressed: () {
      //     // Attach file functionality
      //   },
      // ),
      Expanded(
        child: TextField(
          controller: _messageController,
          minLines: 1,
          maxLines: 5,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Type a message...',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ),
          textInputAction: TextInputAction.newline,
          // onSubmitted: (_) => _sendMessage(),
        ),
      ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: children,
      ),
    );
  }
}
