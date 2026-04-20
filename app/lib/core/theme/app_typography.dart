import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTypography {
  static TextTheme get textTheme => TextTheme(
        displayLarge: GoogleFonts.rubik(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 40 / 32,
        ),
        headlineMedium: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 32 / 24,
        ),
        titleLarge: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 28 / 20,
        ),
        titleMedium: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 24 / 16,
        ),
        bodyLarge: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 24 / 16,
        ),
        bodyMedium: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 20 / 14,
        ),
        labelLarge: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 20 / 14,
        ),
        labelSmall: GoogleFonts.rubik(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 16 / 11,
        ),
      );
}
