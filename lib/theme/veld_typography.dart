import 'package:flutter/material.dart';

/// Bundled font families (see `assets/fonts/` and `pubspec.yaml`).
abstract final class VeldTypography {
  static const frauncesFamily = 'Fraunces';
  static const dmSansFamily = 'DMSans';

  static TextStyle fraunces({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: frauncesFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle dmSans({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    double? height,
  }) {
    return TextStyle(
      fontFamily: dmSansFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      height: height,
    );
  }
}
