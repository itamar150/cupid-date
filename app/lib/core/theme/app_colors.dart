import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFFC4556A);
  static const Color primaryLight = Color(0xFFE8849A);
  static const Color accent = Color(0xFFF0956A);
  static const Color background = Color(0xFFFDF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5EDE8);
  static const Color secondary = Color(0xFF8B7B8B);
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color error = Color(0xFFB00020);
  static const Color success = Color(0xFF2E7D32);
  static const Color divider = Color(0xFFE8E0EC);

  static ColorScheme get colorScheme => const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: surface,
        primaryContainer: primaryLight,
        onPrimaryContainer: textPrimary,
        secondary: secondary,
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
