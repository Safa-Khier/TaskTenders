import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/widgets/list_item.dart';

@RoutePage()
class ClientSearchPage extends StatelessWidget {
  const ClientSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'tasktenders',
                style: TextStyle(
                    color: Color(0xFF00CED1),
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),

              bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'Categories',
                  ),
                  Tab(text: 'Interest'),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0.33,
                dividerColor: Color(0xFF000000).withAlpha(76),
              ),
              // PreferredSize(
              //   preferredSize: const Size.fromHeight(105), // Extend height
              //   child: AppBar(
              //     title: const Text(
              //       'tasktenders',
              //       style: TextStyle(
              //           color: Color(0xFF00CED1),
              //           fontWeight: FontWeight.w600,
              //           fontSize: 20),
              //     ),
              //     bottom: TabBar(tabs: [
              //       Tab(text: 'Categories'),
              //       Tab(text: 'Interest'),
              //     ]),
              // flexibleSpace: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              //     child: Column(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //           MainInput(
              //               hintText: 'Search',
              //               borderRadius: 10,
              //               leadingIcon: Icons.search,
              //               trailingIcon: Icons.clear,
              //               fontSize: 13,
              //               height: 36,
              //               color: Color(0xFF999999),
              //               onTextChanged: (str) {}),
              //           TabBar(tabs: [
              //             Tab(text: 'Categories'),
              //             Tab(text: 'Interest'),
              //           ])
              //         ])),
              // ),
            ),
            body: TabBarView(children: [
              _buildCatagories(),
              _buildInterest(),
            ])));
  }

  Widget _buildCatagories() {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListItem(
            height: 65,
            iconData: Icons.category,
            onPressed: () {},
            title: 'Category $index',
          );
        });
  }

  Widget _buildInterest() {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListItem(
            height: 65,
            iconData: Icons.star,
            onPressed: () {},
            title: 'Interest $index',
          );
        });
  }
}
