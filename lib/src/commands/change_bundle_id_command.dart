import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

class ChangeBundleIdCommand extends Command {
  @override
  final String name = 'change_bundle_id';

  @override
  final String description = 'Changes the Android package name and iOS bundle identifier in the current project.';

  ChangeBundleIdCommand();

  @override
  void run() {
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      print('Error: Please specify the new bundle ID. Usage: clean_architecture_generator change_bundle_id <new_bundle_id>');
      return;
    }

    final newBundleId = rest.first.trim();
    final bundleRegExp = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$');
    if (!bundleRegExp.hasMatch(newBundleId)) {
      print('Error: Invalid bundle identifier/package name format. E.g. com.example.app');
      return;
    }

    print('Changing bundle identifier to "$newBundleId"...');

    final projectDir = Directory.current.path;

    // 1. Update Android configurations
    _updateAndroid(projectDir, newBundleId);

    // 2. Update iOS configurations
    _updateIos(projectDir, newBundleId);

    print('Bundle identifier successfully updated to "$newBundleId"!');
  }

  void _updateAndroid(String projectDir, String newBundleId) {
    final buildGradleFile = File(p.join(projectDir, 'android/app/build.gradle'));
    if (buildGradleFile.existsSync()) {
      print('Updating android/app/build.gradle...');
      var content = buildGradleFile.readAsStringSync();
      // Replace applicationId
      content = content.replaceAll(
        RegExp(r'''applicationId\s+["'][a-zA-Z0-9_\.]+["']'''),
        'applicationId "$newBundleId"',
      );
      // Replace namespace
      content = content.replaceAll(
        RegExp(r'''namespace\s+["'][a-zA-Z0-9_\.]+["']'''),
        'namespace "$newBundleId"',
      );
      buildGradleFile.writeAsStringSync(content);
    }

    final manifestFile = File(p.join(projectDir, 'android/app/src/main/AndroidManifest.xml'));
    if (manifestFile.existsSync()) {
      print('Updating android/app/src/main/AndroidManifest.xml...');
      var content = manifestFile.readAsStringSync();
      content = content.replaceAll(
        RegExp(r'''package\s*=\s*["'][a-zA-Z0-9_\.]+["']'''),
        'package="$newBundleId"',
      );
      manifestFile.writeAsStringSync(content);
    }

    // Update MainActivity package & folder layout
    final kotlinDir = Directory(p.join(projectDir, 'android/app/src/main/kotlin'));
    final javaDir = Directory(p.join(projectDir, 'android/app/src/main/java'));

    if (kotlinDir.existsSync()) {
      _renameMainActivity(kotlinDir, newBundleId, '.kt');
    }
    if (javaDir.existsSync()) {
      _renameMainActivity(javaDir, newBundleId, '.java');
    }
  }

  void _renameMainActivity(Directory baseDir, String newBundleId, String extension) {
    // Find MainActivity file recursively
    File? mainActivityFile;
    try {
      final entities = baseDir.listSync(recursive: true);
      for (final entity in entities) {
        if (entity is File && p.basename(entity.path) == 'MainActivity$extension') {
          mainActivityFile = entity;
          break;
        }
      }
    } catch (_) {}

    if (mainActivityFile == null) return;

    print('Found MainActivity at ${mainActivityFile.path}');
    var content = mainActivityFile.readAsStringSync();

    // Find old package name from file contents
    final packageMatch = RegExp(r'package\s+([a-zA-Z0-9_\.]+);?').firstMatch(content);
    if (packageMatch == null) return;

    final oldPackageName = packageMatch.group(1)!;
    print('Old package name detected: $oldPackageName');

    // Replace package statement
    content = content.replaceAll(
      RegExp('package\\s+$oldPackageName;?'),
      'package $newBundleId;',
    );
    mainActivityFile.writeAsStringSync(content);

    // Relocate MainActivity to new package folder structure
    final newSubPath = newBundleId.replaceAll('.', '/');
    final targetDir = Directory(p.join(baseDir.path, newSubPath));
    if (!targetDir.existsSync()) {
      targetDir.createSync(recursive: true);
    }

    final newFilePath = p.join(targetDir.path, 'MainActivity$extension');
    if (newFilePath != mainActivityFile.path) {
      print('Moving MainActivity to new package location: $newFilePath');
      mainActivityFile.renameSync(newFilePath);

      // Clean up old empty directories recursively up to baseDir
      var parent = mainActivityFile.parent;
      while (parent.path != baseDir.path && parent.path.startsWith(baseDir.path)) {
        try {
          if (parent.listSync().isEmpty) {
            print('Removing empty old package directory: ${parent.path}');
            parent.deleteSync();
          } else {
            break;
          }
        } catch (_) {
          break;
        }
        parent = parent.parent;
      }
    }
  }

  void _updateIos(String projectDir, String newBundleId) {
    final pbxprojFile = File(p.join(projectDir, 'ios/Runner.xcodeproj/project.pbxproj'));
    if (pbxprojFile.existsSync()) {
      print('Updating ios/Runner.xcodeproj/project.pbxproj...');
      var content = pbxprojFile.readAsStringSync();
      content = content.replaceAll(
        RegExp(r'PRODUCT_BUNDLE_IDENTIFIER\s*=\s*[a-zA-Z0-9_\.\$\{\}]+;'),
        'PRODUCT_BUNDLE_IDENTIFIER = $newBundleId;',
      );
      pbxprojFile.writeAsStringSync(content);
    }
  }
}
