import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'veld_colors.dart';

abstract final class VeldTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: VeldColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: VeldColors.sage,
        brightness: Brightness.light,
        surface: VeldColors.surface,
        onSurface: VeldColors.ink,
      ),
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: VeldColors.background,
        foregroundColor: VeldColors.ink,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: VeldColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: VeldColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: VeldColors.sage,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VeldColors.ink,
          side: const BorderSide(color: VeldColors.sage),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return TextTheme(
      displaySmall: GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: VeldColors.ink,
      ),
      titleLarge: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: VeldColors.ink,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: VeldColors.ink,
      ),
      bodyLarge: GoogleFonts.dmSans(fontSize: 16, color: VeldColors.ink),
      bodyMedium: GoogleFonts.dmSans(fontSize: 14, color: VeldColors.inkMuted),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: VeldColors.ink,
      ),
    );
  }
}
