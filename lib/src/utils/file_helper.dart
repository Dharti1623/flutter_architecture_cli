import 'dart:io';

class FileHelper {
  /// Writes [content] to the [path], creating any parent directories.
  static void writeFile(String path, String content) {
    final file = File(path);
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    file.writeAsStringSync(content);
  }

  /// Appends [content] to the [path].
  static void appendFile(String path, String content) {
    final file = File(path);
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    file.writeAsStringSync(content, mode: FileMode.append);
  }

  /// Checks if file/directory exists.
  static bool exists(String path) {
    return File(path).existsSync() || Directory(path).existsSync();
  }

  /// Read file content.
  static String readFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      return '';
    }
    return file.readAsStringSync();
  }
}
