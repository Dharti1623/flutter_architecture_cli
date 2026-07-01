import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';

class CreateScreenCommand extends Command {
  @override
  final String name = 'create_screen';

  @override
  final String description = 'Generates a new presentation screen in the current project.';

  CreateScreenCommand() {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'The target feature folder inside lib/src/ where the screen should be created.',
    );
  }

  String _getPackageName() {
    final file = File(p.join(Directory.current.path, 'pubspec.yaml'));
    if (!file.existsSync()) return 'app';
    final lines = file.readAsLinesSync();
    for (final line in lines) {
      if (line.trim().startsWith('name:')) {
        return line.split('name:').last.trim();
      }
    }
    return 'app';
  }

  @override
  void run() {
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      print('Error: Please specify the screen name. Usage: clean_architecture_generator create_screen <screen_name>');
      return;
    }

    final screenName = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);
    final featureName = StringUtils.toSnakeCase(argResults?['feature'] ?? screenName);
    final packageName = _getPackageName();
    
    final targetPath = p.join(
      Directory.current.path,
      'lib/src',
      featureName,
      'presentation',
      'view',
      '${screenName}_screen.dart',
    );

    if (FileHelper.exists(targetPath)) {
      print('Error: Screen already exists at $targetPath');
      return;
    }

    final content = '''
import 'package:flutter/material.dart';
import 'package:$packageName/common/widgets/app_text.dart';

class ${className}Screen extends StatelessWidget {
  static const String routeName = '/$screenName';

  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: '$className'),
      ),
      body: const Center(
        child: AppText(text: 'Welcome to $className Screen'),
      ),
    );
  }
}
''';

    FileHelper.writeFile(targetPath, content);
    print('Generated Screen: $targetPath');
  }
}
