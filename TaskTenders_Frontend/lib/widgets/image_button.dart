import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final BuildContext context; // Build context
  final VoidCallback onPressed; // Function to be executed when pressed
  final String imagePath; // Text displayed on the button
  final Color color; // Color for the button

  const ImageButton({
    super.key,
    required this.context,
    required this.onPressed,
    required this.imagePath,
    Color? color,
  }) : color = color ?? const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final Color effectiveColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFC6C6C6)
        : color;

    return Expanded(
        child: SizedBox(
            height: 52,
            child: OutlinedButton(
                onPressed: onPressed,
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    const BorderSide(
                        color: Colors.transparent,
                        width: 1), // Edge color and thickness
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      // Color when button is pressed
                      return effectiveColor.withOpacity(0.5);
                    }
                    // Default color
                    return effectiveColor;
                  }),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Rounded corners
                    ),
                  ),
                  overlayColor: WidgetStateProperty.all(
                      Colors.transparent), // No overlay color
                ),
                child: Image(
                  image: AssetImage(imagePath),
                  width: 30,
                  fit: BoxFit
                      .contain, // Ensures the image maintains size within bounds
                ))));
  }
}
