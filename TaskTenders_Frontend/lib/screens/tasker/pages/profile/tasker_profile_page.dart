import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/widgets/list_item.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class TaskerProfilePage extends StatefulWidget {
  const TaskerProfilePage({super.key});

  @override
  State<TaskerProfilePage> createState() => _TaskerProfilePageState();
}

class _TaskerProfilePageState extends State<TaskerProfilePage> {
  final UserService _userService = locator<UserService>();
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion =
            'Version ${packageInfo.version}(${packageInfo.buildNumber})';
      });
    } catch (e) {
      debugPrint('Error fetching app version: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(105), // Extend height
        child: AppBar(
            actions: [
              IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {})
            ],
            backgroundColor: Theme.of(context).colorScheme.primary,
            // backgroundColor: Color(0xFF00C6C6),
            flexibleSpace: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF999999),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                width: 20,
                                height: 20,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                  size: 15,
                                ),
                              )
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              AutoRouter.of(context).push(TaskerAccountRoute());
                            },
                            child: Text(_userService.getUserName(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20)),
                          )
                        ],
                      ),
                    ]))),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ListTile(
            title: Text('Settings',
                style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
          ),
          ListItem(
              title: 'Preferences',
              iconData: Icons.settings_outlined,
              onPressed: () {}),
          ListItem(
              title: 'Account',
              iconData: Icons.manage_accounts_outlined,
              onPressed: () {
                AutoRouter.of(context).push(TaskerAccountRoute());
              }),
          const SizedBox(height: 20),
          ListTile(
            title: Text('Resources',
                style: TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
          ),
          ListItem(
              title: 'Introduction Tutorial',
              iconData: Icons.question_mark_rounded,
              onPressed: () {
                AutoRouter.of(context).push(IntroRoute());
              }),
          ListItem(
              title: 'Support',
              iconData: Icons.support_sharp,
              onPressed: () {}),
          ListItem(
              title: 'Share feedback',
              iconData: Icons.star_half,
              onPressed: () {}),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Text(
              _appVersion,
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF999999), fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
