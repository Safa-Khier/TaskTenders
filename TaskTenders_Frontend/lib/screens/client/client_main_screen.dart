import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';

@RoutePage()
class ClientMainScreen extends StatelessWidget {
  const ClientMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        ClientHomeRoute(),
        InboxRoute(),
        // ClientSearchRoute(),
        ClientHistoryRoute(),
        ClientProfileRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFF000000).withAlpha(76), // Border color
                  width: 0.33, //
                ),
              ),
            ),
            child: BottomNavigationBar(
              // showUnselectedLabels: false,
              fixedColor: Color(0xFF00CED1),
              unselectedItemColor: Color(0xFF999999),
              type: BottomNavigationBarType.fixed,
              unselectedLabelStyle: TextStyle(
                fontSize: 0,
              ),
              selectedLabelStyle: TextStyle(fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail_outlined),
                  activeIcon: Icon(Icons.mail),
                  label: 'Inbox',
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.search),
                //   label: 'Search',
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outlined),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              onTap: tabsRouter.setActiveIndex,
              currentIndex: tabsRouter.activeIndex,
            ));
      },
    );
  }
}
