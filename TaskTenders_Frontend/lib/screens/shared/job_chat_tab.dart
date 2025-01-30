import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/models/message.model.dart';
import 'package:tasktender_frontend/screens/shared/loading_screen.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';

class JobChatTab extends StatefulWidget {
  final Job job;

  const JobChatTab({super.key, required this.job});

  @override
  State<JobChatTab> createState() => _JobChatTabState();
}

class _JobChatTabState extends State<JobChatTab> {
  final UserService _userService = locator<UserService>();
  final JobService _jobService = locator<JobService>();
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

    if (widget.job.status == 'open') {
      _jobService.sendMessageInJobChat(widget.job.id!, message,
          chatName: 'tenderChat');
    } else {
      _jobService.sendMessageInJobChat(widget.job.id!, message);
    }
  }

  Stream<List<Message>> getJobChatMessages(String jobId) {
    if (widget.job.status == 'open') {
      return _jobService.getJobChatMessages(jobId, chatName: 'tenderChat');
    }
    return _jobService.getJobChatMessages(jobId);
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.job.status == 'open') {
    //   return Center(
    //     child: Text('There is no Chat yet!'),
    //   );
    // }
    return SafeArea(
      child: FocusScope(
          node: FocusScopeNode(),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<List<Message>>(
                stream: getJobChatMessages(
                    widget.job.id!), // Pass the jobId to fetch messages
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
              if (widget.job.status != 'canceled' &&
                  widget.job.status != 'completed') ...[
                _buildMessageInput(),
              ],
            ],
          )),
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

  Widget _buildMessageItem(Message message) {
    final bool isMe = message.senderId == _userService.getUserUid();
    final bool isTenderMode = widget.job.status == 'open';
    final bool isCurrentUserClient = _userService.getUserRole() == 'client';
    final bool isSenderClient = message.senderId == widget.job.userId;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((!isMe && (isTenderMode || isSenderClient))) ...[
              Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                child: Center(
                  child: CircleAvatar(
                      radius: 15,
                      // backgroundImage:
                      //     ((isCurrentUserClient || isSenderClient) &&
                      //             message.senderImageUrl != null)
                      //         ? NetworkImage(message.senderImageUrl ?? '')
                      //         : null,
                      child: isCurrentUserClient || isSenderClient
                          ? Text(message.senderName[0].toUpperCase())
                          : Text(message.senderId[0].toUpperCase())),
                ),
              ),

              // const SizedBox(width: 10),
            ],
            Container(
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
                    if (!isMe && (isTenderMode || isSenderClient)) ...[
                      Text(
                        isCurrentUserClient || isSenderClient
                            ? '${message.senderName}${isSenderClient ? ' (Client)' : ''}'
                            : 'Tasker - ${message.senderId.substring(0, 3)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      // const SizedBox(width: 10),
                    ],
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
                ))
          ]),
    );
  }
}
