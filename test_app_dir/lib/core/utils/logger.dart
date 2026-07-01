import 'dart:developer';

class Logger {
  static void info(String message) => log('INFO: $message');
  static void error(String message) => log('ERROR: $message');
}
