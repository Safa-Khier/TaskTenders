import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';
import 'package:tasktender_frontend/utils/date_utils.dart';

class ChatListItem extends StatefulWidget {
  final String userName;
  final String lastMessage;
  final DateTime date;
  final String? userImageUrl;
  final VoidCallback onPressed;

  const ChatListItem(
      {super.key,
      required this.userName,
      required this.lastMessage,
      required this.date,
      required this.onPressed,
      this.userImageUrl});

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.brown,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.grey,
    Colors.blueGrey,
  ];

  Widget getUserImg() {
    if (widget.userImageUrl != null) {
      return CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(widget.userImageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: 25,
        // background random color for user image, Randoooom !!!!
        backgroundColor: colors[Random().nextInt(colors.length)],
        child: Text(
          widget.userName[0].toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
    }
  }

  Widget getTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.userName,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            )),
        // const SizedBox(height: 5),
        Text(widget.lastMessage,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 12)),
      ],
    );
  }

  Widget getDate() {
    // if today show time else show date
    if (isToday(widget.date)) {
      final int diff = getDifferenceInMinutes(widget.date);
      print(diff);
      if (diff == 0) {
        return Text(
          'Just Now',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        );
      } else if (diff < 60) {
        return Text(
          '$diff minutes ago',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        );
      }

      return Text(
        getDateInFormat(date: widget.date, format: 'hh:mm a'),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
        ),
      );
    } else {
      return Text(
        getDateInFormat(date: widget.date, format: 'dd MMMM yyyy'),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Theme.of(context)
                  .extension<CustomThemeExtension>()
                  ?.listItemBackground ??
              Colors.white),
          side: WidgetStateProperty.all(
            const BorderSide(
              color: Color(0xAA999999),
              width: 0.25,
            ), // Edge color and thickness
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // Rounded corners
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.all(0),
          ),
          overlayColor:
              WidgetStateProperty.all(Colors.transparent), // No overlay color
        ),
        onPressed: widget.onPressed,
        child: Container(
            padding: EdgeInsets.all(10),
            height: 70,
            child: Row(
              children: [
                // const SizedBox(width: 15),
                getUserImg(),
                const SizedBox(width: 15),
                getTitle(),
                Spacer(),
                Column(
                  children: [getDate()],
                )
              ],
            )));
  }
}
