import 'package:flutter/material.dart';

// FIXME: Fix the color of the button
class MainButton extends StatelessWidget {
  final BuildContext context; // Build context
  final VoidCallback? onPressed; // Function to be executed when pressed
  final double textSize; // Text size
  final String text; // Text displayed on the button
  final FontWeight fontWeight; // Font weight of the text
  final Color color; // Color for the button
  final bool isOutlined; // Whether the button is outlined

  const MainButton(
      {super.key,
      required this.context,
      required this.onPressed,
      required this.text,
      this.color = const Color(0xFF00CED1),
      this.textSize = 16,
      this.fontWeight = FontWeight.bold,
      this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = Theme.of(context).colorScheme.primary;

    return SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            side: WidgetStateProperty.all(
              BorderSide(
                  color: isOutlined ? effectiveColor : Colors.transparent,
                  width: 1), // Edge color and thickness
            ),
            foregroundColor: WidgetStateProperty.all(
                isOutlined ? color : Colors.white), // Text color
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                // Color when button is pressed
                return effectiveColor.withOpacity(isOutlined ? 0.2 : 0.5);
              }
              // Default color
              return effectiveColor.withOpacity(isOutlined ? 0 : 1);
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
            ),
            overlayColor:
                WidgetStateProperty.all(Colors.transparent), // No overlay color
            textStyle: WidgetStateProperty.all(
              TextStyle(
                fontSize: textSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
          child: Text(text),
        ));
  }
}
