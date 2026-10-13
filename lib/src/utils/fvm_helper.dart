import 'dart:io';
import 'package:path/path.dart' as p;
import 'file_helper.dart';

/// Helper utility for detecting and running commands via FVM (Flutter Version Management) or system Flutter.
class FvmHelper {
  FvmHelper._();

  /// Checks if a command executable is available in the system PATH.
  static bool isCommandAvailable(String command) {
    try {
      final checkCmd = Platform.isWindows ? 'where' : 'which';
      final result = Process.runSync(
        checkCmd,
        [command],
        runInShell: true,
      );
      return result.exitCode == 0 && result.stdout.toString().trim().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Checks if a directory contains an .fvm folder or .fvmrc file.
  static bool isFvmConfigured([String? directoryPath]) {
    final dir = directoryPath ?? FileHelper.findProjectRoot();
    return Directory(p.join(dir, '.fvm')).existsSync() ||
        File(p.join(dir, '.fvmrc')).existsSync();
  }

  /// Determines whether FVM should be used based on an explicit flag, workspace configuration, or PATH state.
  static bool shouldUseFvm({bool explicitFvm = false, String? directoryPath}) {
    if (explicitFvm) return true;

    final fvmAvailable = isCommandAvailable('fvm');
    if (!fvmAvailable) return false;

    // Auto-detect if workspace already has .fvm directory
    if (isFvmConfigured(directoryPath)) {
      return true;
    }

    // Auto-detect if system flutter is missing but fvm is available
    if (!isCommandAvailable('flutter')) {
      return true;
    }

    return false;
  }

  /// Runs a Flutter command using either `fvm flutter` or `flutter`.
  static ProcessResult runFlutter(
    List<String> arguments, {
    bool useFvm = false,
    String? workingDirectory,
  }) {
    final executable = useFvm ? 'fvm' : 'flutter';
    final args = useFvm ? ['flutter', ...arguments] : arguments;

    return Process.runSync(
      executable,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );
  }

  /// Runs a Dart command using either `fvm dart` or `dart`.
  static ProcessResult runDart(
    List<String> arguments, {
    bool useFvm = false,
    String? workingDirectory,
  }) {
    final executable = useFvm ? 'fvm' : 'dart';
    final args = useFvm ? ['dart', ...arguments] : arguments;

    return Process.runSync(
      executable,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );
  }

  /// Sets up FVM configuration in the target project (.gitignore, .vscode/settings.json, fvm use).
  static void configureFvmProject(
    String targetDir, {
    String? fvmVersion,
  }) {
    // 1. If a specific FVM version is requested, run `fvm use <version>`
    if (fvmVersion != null && fvmVersion.trim().isNotEmpty) {
      print('Pinning Flutter version "$fvmVersion" with FVM in $targetDir...');
      final useResult = Process.runSync(
        'fvm',
        ['use', fvmVersion, '--force'],
        workingDirectory: targetDir,
        runInShell: true,
      );
      if (useResult.stdout != null &&
          useResult.stdout.toString().trim().isNotEmpty) {
        print(useResult.stdout);
      }
      if (useResult.stderr != null &&
          useResult.stderr.toString().trim().isNotEmpty) {
        print(useResult.stderr);
      }
    }

    // 2. Ensure .fvm/flutter_sdk is ignored in .gitignore
    final gitignorePath = p.join(targetDir, '.gitignore');
    final gitignoreFile = File(gitignorePath);
    if (gitignoreFile.existsSync()) {
      final content = gitignoreFile.readAsStringSync();
      if (!content.contains('.fvm/flutter_sdk')) {
        FileHelper.appendFile(
          gitignorePath,
          '\n# FVM (Flutter Version Management)\n.fvm/flutter_sdk\n',
        );
      }
    }

    // 3. Setup VS Code settings for seamless FVM Flutter SDK detection
    final vscodeDir = Directory(p.join(targetDir, '.vscode'));
    if (!vscodeDir.existsSync()) {
      vscodeDir.createSync(recursive: true);
    }
    final vscodeSettingsPath = p.join(vscodeDir.path, 'settings.json');
    final vscodeSettingsFile = File(vscodeSettingsPath);
    if (!vscodeSettingsFile.existsSync()) {
      FileHelper.writeFile(
        vscodeSettingsPath,
        '{\n  "dart.flutterSdkPath": ".fvm/flutter_sdk"\n}\n',
      );
    }
  }
}
