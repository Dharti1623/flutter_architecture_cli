import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_architecture_cli/src/utils/fvm_helper.dart';

void main() {
  group('FvmHelper Tests', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('fvm_helper_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('isCommandAvailable returns boolean without throwing', () {
      expect(FvmHelper.isCommandAvailable('dart'), isTrue);
      expect(
          FvmHelper.isCommandAvailable('non_existent_command_12345'), isFalse);
    });

    test('isFvmConfigured correctly detects .fvm folder', () {
      expect(FvmHelper.isFvmConfigured(tempDir.path), isFalse);

      final fvmDir = Directory(p.join(tempDir.path, '.fvm'));
      fvmDir.createSync();

      expect(FvmHelper.isFvmConfigured(tempDir.path), isTrue);
    });

    test('isFvmConfigured correctly detects .fvmrc file', () {
      expect(FvmHelper.isFvmConfigured(tempDir.path), isFalse);

      final fvmrcFile = File(p.join(tempDir.path, '.fvmrc'));
      fvmrcFile.writeAsStringSync('{}');

      expect(FvmHelper.isFvmConfigured(tempDir.path), isTrue);
    });

    test('shouldUseFvm returns true when explicitFvm is true', () {
      expect(FvmHelper.shouldUseFvm(explicitFvm: true), isTrue);
    });

    test(
        'configureFvmProject creates .gitignore and .vscode/settings.json entries',
        () {
      final gitignoreFile = File(p.join(tempDir.path, '.gitignore'));
      gitignoreFile.writeAsStringSync('build/\n.dart_tool/\n');

      FvmHelper.configureFvmProject(tempDir.path);

      final gitignoreContent = gitignoreFile.readAsStringSync();
      expect(gitignoreContent.contains('.fvm/flutter_sdk'), isTrue);

      final vscodeSettings =
          File(p.join(tempDir.path, '.vscode/settings.json'));
      expect(vscodeSettings.existsSync(), isTrue);
      expect(
          vscodeSettings
              .readAsStringSync()
              .contains('"dart.flutterSdkPath": ".fvm/flutter_sdk"'),
          isTrue);
    });
  });
}
