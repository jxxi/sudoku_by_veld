import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/app_logger.dart';

/// Installs global Flutter and platform error handlers.
void setupGlobalErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(
      'Flutter framework error',
      details.exception,
      details.stack,
    );

    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('Uncaught platform error', error, stack);
    return true;
  };
}

/// Runs [body] inside a guarded zone so uncaught async errors are logged.
Future<void> runGuarded(Future<void> Function() body) async {
  await runZonedGuarded(
    body,
    (error, stack) {
      AppLogger.error('Uncaught zone error', error, stack);
    },
  );
}
