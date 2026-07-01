import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';

class CreateRepositoryCommand extends Command {
  @override
  final String name = 'create_repository';

  @override
  final String description = 'Generates a new repository in the project.';

  CreateRepositoryCommand() {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'The target feature folder inside lib/src/ where the repository should be created.',
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
      print('Error: Please specify the repository name. Usage: flutter_architecture_cli create_repository <name>');
      return;
    }

    final repoName = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);
    final featureName = StringUtils.toSnakeCase(argResults?['feature'] ?? repoName);
    final packageName = _getPackageName();

    final targetPath = p.join(Directory.current.path, 'lib/src', featureName, 'repository', '${repoName}_repository.dart');

    FileHelper.writeFile(targetPath, '''
import 'package:$packageName/src/$featureName/data_source/${repoName}_datasource.dart';

class ${className}Repository {
  // ignore: unused_field
  final ${className}DataSource _dataSource = ${className}DataSource();

  // Add repository operations
}
''');

    print('Generated Repository: $targetPath');
  }
}
