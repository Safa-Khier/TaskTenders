import 'package:flutter/material.dart';
import 'package:tasktender_frontend/utils/app.colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? darkPalette.gradientBackground
            : lightPalette.gradientBackground,
      ),
      child: child,
    );
  }
}
