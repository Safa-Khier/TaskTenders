import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/chat.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/screens/shared/loading_screen.dart';
import 'package:tasktender_frontend/services/chat.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/widgets/chat_list_item.dart';
// import 'package:tasktender_frontend/screens/shared/inbox/inbox_screen_placeholder.dart';

@RoutePage()
class InboxPage extends StatelessWidget {
  final UserService _userService = locator<UserService>();
  final ChatService _chatService = locator<ChatService>();

  InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Center(
              child: Text('Edit',
                  style: TextStyle(color: Color(0xFF00CED1), fontSize: 16))),
          title: const Text(
            'Inbox',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(icon: Icon(Icons.filter_list), onPressed: () {})
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: Color(0xFF000000).withAlpha(76),
                            width: 0.33))),
              )),
        ),
        body: StreamBuilder<List<Chat>>(
          stream: _chatService.getChats(), // Pass the jobId to fetch messages
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen(); // Loading state
            }

            if (snapshot.hasError) {
              debugPrint('Error: ${snapshot.error}');
              return Text("Error: ${snapshot.error}"); // Error state
            }

            final chats = snapshot.data ?? [];

            return ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              // reverse: true,
              // padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final Chat chat = chats[index];
                return ChatListItem(
                    userName: _userService.getUserRole() == 'client'
                        ? chat.taskerName
                        : chat.clientName,
                    lastMessage: chat.lastMessage,
                    date: chat.lastMessageTimestamp,
                    onPressed: () {
                      context.router
                          .push(ChatRoute(chat: chat, chatId: chat.id));
                    });
              },
            );
          },
        ));
  }
}
