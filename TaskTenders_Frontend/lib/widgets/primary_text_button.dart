import 'package:flutter/material.dart';

/// Custom text button that changes color when pressed
///
/// This widget is a custom text button that changes color when pressed. It is
class PrimaryTextButton extends StatelessWidget {
  final VoidCallback onPressed; // Function to be executed when pressed
  final double textSize; // Text size
  final String text; // Text displayed on the button
  final FontWeight fontWeight; // Font weight of the text
  final Color baseColor; // Color for the text when not pressed
  final Color pressedColor; // Color for the text when pressed
  final IconData? leadingIconData; // Leading icon for the button
  final IconData? trailingIconData; // Trailing icon for the button

  const PrimaryTextButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.baseColor = const Color(0xFF3A4F66),
      this.pressedColor = const Color(0xFF00CED1),
      this.textSize = 14,
      this.fontWeight = FontWeight.normal,
      this.leadingIconData,
      this.trailingIconData});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return pressedColor; // Darker blue when the button is pressed
              }
              return baseColor.withOpacity(0.8); // Normal blue when not pressed
            },
          ),
          overlayColor: WidgetStateProperty.all(
              Colors.transparent), // Remove ripple effect
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingIconData != null)
              Icon(
                leadingIconData,
                size: textSize,
              ),
            Text(
              text,
              style: TextStyle(fontSize: textSize, fontWeight: fontWeight),
            ),
            if (trailingIconData != null)
              Icon(
                trailingIconData,
                size: textSize,
                weight: fontWeight.value.toDouble(),
              ),
          ],
        ));
  }
}
