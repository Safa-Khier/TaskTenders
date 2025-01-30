import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.colors.dart'; // Import your color palettes

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color? listItemBackground;
  final Color? baseShimmer;
  final Color? highlightShimmer;
  final Color? shadow;
  final Color? chipBackground;
  final Color? chatSenderBackground;
  final Color? chatReceiverBackground;

  CustomThemeExtension(
      {this.listItemBackground,
      this.baseShimmer,
      this.highlightShimmer,
      this.shadow,
      this.chipBackground,
      this.chatSenderBackground,
      this.chatReceiverBackground});

  @override
  CustomThemeExtension copyWith(
      {Color? listItemBackground,
      Color? baseShimmer,
      Color? highlightShimmer,
      Color? shadow,
      Color? chipBackground,
      Color? chatSenderBackground,
      Color? chatReceiverBackground}) {
    return CustomThemeExtension(
      listItemBackground: listItemBackground ?? this.listItemBackground,
      baseShimmer: baseShimmer ?? this.baseShimmer,
      highlightShimmer: highlightShimmer ?? this.highlightShimmer,
      shadow: shadow ?? this.shadow,
      chipBackground: chipBackground ?? this.chipBackground,
      chatSenderBackground: chatSenderBackground ?? this.chatSenderBackground,
      chatReceiverBackground:
          chatReceiverBackground ?? this.chatReceiverBackground,
    );
  }

  @override
  CustomThemeExtension lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      listItemBackground:
          Color.lerp(listItemBackground, other.listItemBackground, t),
      baseShimmer: Color.lerp(baseShimmer, other.baseShimmer, t),
      highlightShimmer: Color.lerp(highlightShimmer, other.highlightShimmer, t),
    );
  }
}

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPalette.foreground,
    textTheme: GoogleFonts.mulishTextTheme().apply(
      bodyColor: lightPalette.foreground, // Text color for body text
      displayColor: lightPalette.foreground, // Text color for headlines
    ), // Set default font here
    colorScheme: ColorScheme.light(
      primary: lightPalette.primary,
      secondary: lightPalette.secondary,
      surface: lightPalette.background, // Set background color here
      onSurface:
          lightPalette.foreground, // Ideal for text and icons on background
      // Add other colors as needed
    ),
    extensions: [
      CustomThemeExtension(
        listItemBackground: lightPalette.listItemBackground,
        baseShimmer: lightPalette.baseShimmer,
        highlightShimmer: lightPalette.highlightShimmer,
        shadow: lightPalette.shadow,
        chipBackground: lightPalette.chipBackground,
        chatSenderBackground: lightPalette.chatSenderBackground,
        chatReceiverBackground: lightPalette.chatReceiverBackground,
      ),
    ]
    // Other customizations
    );

final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPalette.foreground,
    textTheme: GoogleFonts.mulishTextTheme().apply(
      bodyColor: darkPalette.foreground, // Text color for body text
      displayColor: darkPalette.foreground, // Text color for headlines
    ), // Set default font here
    colorScheme: ColorScheme.dark(
      primary: darkPalette.primary,
      secondary: darkPalette.secondary,
      surface: darkPalette.background, // Set background color here
      onSurface:
          darkPalette.foreground, // Ideal for text and icons on background

      // Add other colors as needed
    ),
    extensions: [
      CustomThemeExtension(
        listItemBackground: darkPalette.listItemBackground,
        baseShimmer: darkPalette.baseShimmer,
        highlightShimmer: darkPalette.highlightShimmer,
        shadow: darkPalette.shadow,
        chipBackground: darkPalette.chipBackground,
        chatSenderBackground: darkPalette.chatSenderBackground,
        chatReceiverBackground: darkPalette.chatReceiverBackground,
      ),
    ]

    // Other customizations
    );

// BoxDecoration getBackgroundGradient(BuildContext context) {
//   final theme = Theme.of(context);
//   final bool isDark = theme.brightness == Brightness.dark;

//   final gradientColors = isDark
//       ? [const Color(0xFF001111), const Color(0xFF004444)]
//       : [const Color(0xFFFFFFFF), const Color(0xFFE8F0FF)];

//   return BoxDecoration(
//     gradient: LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: gradientColors,
//     ),
//   );
// }
