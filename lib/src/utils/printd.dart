import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var _logger = Logger(
  printer: PrettyPrinter(
      methodCount: 5,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 12000,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

void printD(dynamic message,
    {DateTime? time, Object? error, StackTrace? stackTrace}) {
  if (kDebugMode) {
    _logger.d(message, time: time, error: error, stackTrace: stackTrace);
  }
}
