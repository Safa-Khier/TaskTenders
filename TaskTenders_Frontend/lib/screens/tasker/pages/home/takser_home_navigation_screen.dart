import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class TakserHomeNavigationScreen extends StatelessWidget {
  const TakserHomeNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
