import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/services/auth.local.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/date_utils.dart';
import 'package:tasktender_frontend/widgets/list_item.dart';

@RoutePage()
class TaskerAccountPage extends StatefulWidget {
  const TaskerAccountPage({super.key});

  @override
  State<TaskerAccountPage> createState() => _TaskerAccountPageState();
}

class _TaskerAccountPageState extends State<TaskerAccountPage> {
  final UserService _userService = locator<UserService>();
  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0), // Height of the border
            child: Container(
              color: Color(0xFF000000).withAlpha(76), // Border color
              height: 0.33, // Border height
            ),
          ),
          title: const Text(
            'Account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text('Account Info',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
            ),
            ListItem(
                height: 70,
                title: _userService.getUserName(),
                subtitle: 'Username',
                onPressed: () {}),
            ListItem(
                height: 70,
                title: getDateInFormat(
                    date: _userService.userDetails?.dateOfBirth ??
                        DateTime.now()),
                subtitle: 'Date of Birth',
                onPressed: () {}),
            ListItem(
                height: 70,
                title: getUserRole(),
                subtitle: 'Role',
                onPressed: () {}),
            ListItem(
                height: 70,
                title: getMail(),
                subtitle: 'Email',
                onPressed: () async {
                  if (isAuthenticated) {
                    return;
                  }
                  AuthLocalService.authenticate().then((value) {
                    if (value) {
                      print('Authenticated');
                      setState(() {
                        isAuthenticated = true;
                      });
                    } else {
                      print('Not Authenticated');
                    }
                  });
                }),
            ListItem(
                height: 70,
                title: _userService.getUserId(),
                subtitle: 'ID',
                onPressed: () {}),
            ListItem(
                height: 70,
                title: _userService.getUserPhone(),
                subtitle: 'phone',
                onPressed: () {}),
            const SizedBox(height: 20),
            ListItem(
                height: 55,
                title: 'Logout',
                iconData: Icons.logout,
                color: Colors.red,
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text("Logout"),
                          content: Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Logout",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                _userService.logoutUser(context);
                              },
                            ),
                          ],
                        ))),
          ],
        ));
  }

  String getUserRole() {
    switch (_userService.getUserRole()) {
      case 'tasker':
        return 'Tasker';
      case 'client':
        return 'Client';
      case 'admin':
        return 'Admin';
      default:
        return 'Unknown';
    }
  }

  String getMail() {
    final String email = _userService.getUserEmail();
    if (isAuthenticated) {
      //safakhier@gmail.com
      return email;
    } else {
      // s•••••••r@gmail.com
      final int atIndex = email.indexOf('@');
      return email.replaceRange(1, atIndex - 1, '•' * (atIndex - 2));
    }
  }
}
