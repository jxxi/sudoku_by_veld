import 'package:flutter/services.dart';

abstract final class VeldHaptics {
  static void mistake() => HapticFeedback.mediumImpact();

  static void success() => HapticFeedback.heavyImpact();
}
