import 'dart:io';

/// Helper utility class for performing synchronous file operations.
class FileHelper {
  FileHelper._();

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

  /// Finds the project root directory by searching for pubspec.yaml starting from [startDir] upwards.
  /// Defaults to Directory.current.path if pubspec.yaml is not found.
  static String findProjectRoot([String? startDir]) {
    var dir = Directory(startDir ?? Directory.current.path).absolute;
    while (true) {
      final pubspec = File('${dir.path}/pubspec.yaml');
      if (pubspec.existsSync()) {
        return dir.path;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) {
        break;
      }
      dir = parent;
    }
    return startDir ?? Directory.current.path;
  }

  /// Extracts the package name from pubspec.yaml in the project root.
  static String getPackageName([String? startDir]) {
    final root = findProjectRoot(startDir);
    final file = File('$root/pubspec.yaml');
    if (!file.existsSync()) return 'app';
    final lines = file.readAsLinesSync();
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('name:')) {
        final parts = trimmed.split(':');
        if (parts.length > 1) {
          final pkg = parts[1].trim();
          if (pkg.isNotEmpty) return pkg;
        }
      }
    }
    return 'app';
  }
}
