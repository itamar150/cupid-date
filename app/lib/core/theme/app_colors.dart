import 'package:flutter/material.dart';

abstract final class AppColors {
  // Hangly palette
  static const Color primary = Color(0xFFC38EB4);       // mauve pink
  static const Color primaryDark = Color(0xFF28425A);   // dark teal — CTAs
  static const Color accent = Color(0xFFB6A8CF);        // lavender
  static const Color accentDark = Color(0xFF162040);    // deep navy
  static const Color background = Color(0xFFF7F2F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDE5EC);
  static const Color textPrimary = Color(0xFF162040);
  static const Color textSecondary = Color(0xFF28425A);
  static const Color textDisabled = Color(0xFF9BA8B4);
  static const Color error = Color.fromARGB(162, 176, 0, 32);
  static const Color success = Color.fromARGB(104, 46, 125, 50);
  static const Color divider = Color(0xFFE1CBD7);
  static const Color shimmer = Color(0xFFE0D6DF);
  static const Color imageOverlay = Color(0x99000000);
  static const Color onDark = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF162040), Color(0xFF28425A), Color(0xFFC38EB4)],
    stops: [0, 0.65, 1],
  );

    static const LinearGradient heroGradient1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ Color.fromARGB(255, 240, 236, 236), Color.fromARGB(255, 185, 171, 184), Color.fromARGB(255, 191, 168, 180),Color.fromARGB(255, 126, 131, 151)],
    stops: [0, 0.35, 0.65, 1],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF28425A), Color(0xFF162040)],
  );

  static ColorScheme get colorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: surface,
        primaryContainer: accent,
        onPrimaryContainer: accentDark,
        secondary: primaryDark,
        onSecondary: surface,
        secondaryContainer: surfaceVariant,
        onSecondaryContainer: textPrimary,
        tertiary: accent,
        onTertiary: surface,
        error: error,
        onError: surface,
        surface: surface,
        onSurface: textPrimary,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: textSecondary,
        outline: divider,
      );
}
