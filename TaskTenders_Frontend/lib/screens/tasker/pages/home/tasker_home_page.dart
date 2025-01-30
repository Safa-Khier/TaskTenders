import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/screens/client/pages/home/main_screen_placeholder.dart';
import 'package:tasktender_frontend/widgets/main_input.dart';

@RoutePage()
class TaskerHomePage extends StatelessWidget {
  const TaskerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(105), // Extend height
        child: AppBar(
          title: const Text(
            'tasktenders',
            style: TextStyle(
                color: Color(0xFF00CED1),
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
          flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                MainInput(
                    hintText: 'Search',
                    borderRadius: 10,
                    leadingIcon: Icons.search,
                    trailingIcon: Icons.clear,
                    fontSize: 13,
                    height: 36,
                    color: Color(0xFF999999),
                    onTextChanged: (str) {})
              ])),
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
      ),
      body: ShimmerLoadingEffect(),
    );
  }
}
