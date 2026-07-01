import 'dart:developer';

class AppLogger {
  static void debug(String message) {
    log('DEBUG: $message');
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    log('ERROR: $message', error: error, stackTrace: stackTrace);
  }
}
