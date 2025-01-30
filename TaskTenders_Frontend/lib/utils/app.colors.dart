import 'package:flutter/material.dart';

class ColorPalette {
  final Color background;
  final Color foreground;
  final Color primary;
  final Color secondary;
  final Color listItemBackground;
  final Color baseShimmer;
  final Color highlightShimmer;
  final LinearGradient gradientBackground;
  final Color shadow;
  final Color chipBackground;
  final Color chatSenderBackground;
  final Color chatReceiverBackground;

  const ColorPalette(
      {required this.background,
      required this.foreground,
      required this.primary,
      required this.secondary,
      required this.listItemBackground,
      required this.gradientBackground,
      required this.baseShimmer,
      required this.highlightShimmer,
      required this.shadow,
      required this.chipBackground,
      required this.chatSenderBackground,
      required this.chatReceiverBackground});
}

const ColorPalette lightPalette = ColorPalette(
  background: Color(0xFFFBFBFB),
  foreground: Colors.black,
  // foreground: Color(0xFF00CED1),
  primary: Color(0xFF00CED1),
  secondary: Color(0xFF5C5C5C),
  gradientBackground: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFE8F0FF)],
  ),
  listItemBackground: Color(0xFFF8F8F8),
  baseShimmer: Color(0xFFE8E8E8),
  highlightShimmer: Color(0xFFD8D8D8),
  shadow: Color(0x00919191),
  chipBackground: Color.fromARGB(126, 230, 235, 241),
  chatSenderBackground: Color(0xFF6FD3D5),
  chatReceiverBackground: Color(0xFFEEEEEE),
);

const ColorPalette darkPalette = ColorPalette(
  background: Color(0xFF212121),
  foreground: Colors.white,
  // foreground: Color(0xFF009A9C),
  primary: Color(0xFF009A9C),
  secondary: Color(0xFFC1C1C1),
  gradientBackground: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF001111), Color(0xFF004444)],
  ),
  listItemBackground: Color(0xFF333333),
  baseShimmer: Color(0xFF2C2C2C),
  highlightShimmer: Color(0xFF1C1C1C),
  shadow: Color.fromARGB(0, 85, 85, 85),
  chipBackground: Color.fromARGB(160, 30, 30, 30),
  chatSenderBackground: Color.fromARGB(255, 47, 167, 169),
  chatReceiverBackground: Color.fromARGB(255, 65, 65, 65),
);
