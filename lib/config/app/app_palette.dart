import 'package:flutter/material.dart';

class AppPalette {
  // Theme Mode Colors
  static const Color lightMode = Color(0xFFF0F0F0); // Replaces white
  static const Color darkMode = Color(0xFF000001); // Replaces black

  // Primary Brand Colors
  static const Color neonLime = Color(
    0xFFE0F11F,
  ); // Primary brand color (dark theme)
  static const Color vibrantBlue = Color(
    0xFF1F67F1,
  ); // Primary brand color (light theme)
  static const Color electricLime = Color(
    0xFFB8D916,
  ); // Darker lime green (accent)
  static const Color brightLime = Color(
    0xFF9FE01D,
  ); // Medium lime green (secondary)

  // Neutral Colors
  static const Color charcoalGray = Color(0xFF778180); // Main gray
  static const Color darkCharcoal = Color(0xFF282828); // Dark gray accent
  static const Color mediumGray = Color(
    0xFF404040,
  ); // Medium dark gray (onSurface)
  static const Color lightGray = Color(0xFFE8E8E8); // Light gray surface
  static const Color mutedGray = Color(
    0xFF5A6B6A,
  ); // Muted green-gray (outline)

  // Status Colors
  static const Color crimsonRed = Color(0xFFB00020); // Error red
  static const Color rosePink = Color(0xFFFF4F7A); // Rose pink
  static const Color forestGreen = Color(0xFF4CAF50); // Success green
  static const Color goldenYellow = Color(0xFFFFC107); // Warning yellow

  // Dynamic primary color based on theme
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? neonLime
        : vibrantBlue;
  }

  // Theme-aware color methods
  static Color adaptiveColor(
    BuildContext context, {
    Color light = lightMode,
    Color? dark,
  }) {
    final darkColor = dark ?? darkMode;
    return Theme.of(context).brightness == Brightness.dark ? darkColor : light;
  }

  static Color reverseAdaptiveColor(
    BuildContext context, {
    Color? light,
    Color dark = lightMode,
  }) {
    final lightColor = light ?? darkMode;
    return Theme.of(context).brightness == Brightness.dark ? dark : lightColor;
  }

  static ThemeData themeData(ThemeMode mode) {
    return ThemeData(
      brightness: mode == ThemeMode.dark ? Brightness.dark : Brightness.light,
      colorScheme: mode == ThemeMode.dark
          ? const ColorScheme.dark(
              primary: neonLime,
              onSurface: darkMode,
              surface: darkCharcoal,
            )
          : const ColorScheme.light(
              primary: vibrantBlue,
              onSurface: lightMode,
              surface: lightMode,
            ),
      scaffoldBackgroundColor: mode == ThemeMode.dark ? darkMode : lightMode,
      // ...add more theme customization as needed...
    );
  }
}
