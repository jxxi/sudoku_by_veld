import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warn,
  error,
}

/// Lightweight app logger backed by [developer.log].
///
/// Debug logs are stripped in release builds via [kDebugMode].
abstract final class AppLogger {
  static const _name = 'SudokuByVeld';

  static void debug(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (!kDebugMode) return;
    _emit(LogLevel.debug, message, error, stackTrace);
  }

  static void info(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _emit(LogLevel.info, message, error, stackTrace);
  }

  static void warn(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _emit(LogLevel.warn, message, error, stackTrace);
  }

  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _emit(LogLevel.error, message, error, stackTrace);
  }

  static void _emit(
    LogLevel level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    final tagged = '[${level.name.toUpperCase()}] $message';
    developer.log(
      tagged,
      name: _name,
      level: _severity(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static int _severity(LogLevel level) => switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warn => 900,
        LogLevel.error => 1000,
      };
}
