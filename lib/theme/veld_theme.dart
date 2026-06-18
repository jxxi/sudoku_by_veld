import 'package:flutter/material.dart';

import 'veld_colors.dart';
import 'veld_typography.dart';

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
        titleTextStyle: VeldTypography.fraunces(
          fontSize: 22,
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
          textStyle: VeldTypography.dmSans(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: VeldColors.ink,
          side: const BorderSide(color: VeldColors.sage),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: VeldTypography.dmSans(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return TextTheme(
      displaySmall: VeldTypography.fraunces(
        fontSize: 32,
        color: VeldColors.ink,
      ),
      titleLarge: VeldTypography.fraunces(
        fontSize: 22,
        color: VeldColors.ink,
      ),
      titleMedium: VeldTypography.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: VeldColors.ink,
      ),
      bodyLarge: VeldTypography.dmSans(fontSize: 16, color: VeldColors.ink),
      bodyMedium: VeldTypography.dmSans(fontSize: 14, color: VeldColors.inkMuted),
      labelLarge: VeldTypography.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: VeldColors.ink,
      ),
    );
  }
}
