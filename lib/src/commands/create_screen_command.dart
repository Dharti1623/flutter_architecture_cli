import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';
import '../utils/fvm_helper.dart';

class CreateScreenCommand extends Command {
  @override
  final String name = 'create_screen';

  @override
  final String description =
      'Generates a new presentation screen in the current project.';

  CreateScreenCommand() {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help:
          'The target feature folder inside lib/src/ where the screen should be created.',
    );
    argParser.addFlag(
      'fvm',
      negatable: false,
      help:
          'Use FVM (Flutter Version Management) when formatting generated code.',
    );
  }

  @override
  void run() {
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      print(
          'Error: Please specify the screen name. Usage: flutter_architecture_cli create_screen <screen_name>');
      return;
    }

    final projectDir = FileHelper.findProjectRoot();
    final screenName = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);
    final featureName =
        StringUtils.toSnakeCase(argResults?['feature'] ?? screenName);
    final packageName = FileHelper.getPackageName(projectDir);

    final targetPath = p.join(
      projectDir,
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
    final useFvm =
        FvmHelper.shouldUseFvm(explicitFvm: argResults?['fvm'] == true);
    FvmHelper.runDart(['format', targetPath], useFvm: useFvm);
    print('Generated Screen: $targetPath');
  }
}
