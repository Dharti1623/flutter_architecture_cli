import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';
import '../utils/fvm_helper.dart';

class CreateRepositoryCommand extends Command {
  @override
  final String name = 'create_repository';

  @override
  final String description = 'Generates a new repository in the project.';

  CreateRepositoryCommand() {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help:
          'The target feature folder inside lib/src/ where the repository should be created.',
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
          'Error: Please specify the repository name. Usage: flutter_architecture_cli create_repository <name>');
      return;
    }

    final projectDir = FileHelper.findProjectRoot();
    final repoName = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);
    final featureName =
        StringUtils.toSnakeCase(argResults?['feature'] ?? repoName);
    final packageName = FileHelper.getPackageName(projectDir);

    final targetPath = p.join(projectDir, 'lib/src', featureName, 'repository',
        '${repoName}_repository.dart');

    final dataSourceDir =
        Directory(p.join(projectDir, 'lib/src', featureName, 'data_source'));
    String dataSourceImport = '';
    String dataSourceField = '';

    String? foundDataSourceFile;
    String? foundDataSourceClass;

    final exactFile =
        File(p.join(dataSourceDir.path, '${repoName}_datasource.dart'));
    if (exactFile.existsSync()) {
      foundDataSourceFile = '${repoName}_datasource.dart';
      foundDataSourceClass = '${className}DataSource';
    } else {
      final featureDsFile =
          File(p.join(dataSourceDir.path, '${featureName}_datasource.dart'));
      if (featureDsFile.existsSync()) {
        foundDataSourceFile = '${featureName}_datasource.dart';
        foundDataSourceClass =
            '${StringUtils.toPascalCase(featureName)}DataSource';
      } else if (dataSourceDir.existsSync()) {
        try {
          final files = dataSourceDir
              .listSync()
              .whereType<File>()
              .where((f) => f.path.endsWith('_datasource.dart'))
              .toList();
          if (files.isNotEmpty) {
            final f = files.first;
            foundDataSourceFile = p.basename(f.path);
            final prefix =
                foundDataSourceFile.replaceAll('_datasource.dart', '');
            foundDataSourceClass =
                '${StringUtils.toPascalCase(prefix)}DataSource';
          }
        } catch (_) {}
      }
    }

    if (foundDataSourceFile != null && foundDataSourceClass != null) {
      dataSourceImport =
          "import 'package:$packageName/src/$featureName/data_source/$foundDataSourceFile';\n\n";
      dataSourceField =
          '  // ignore: unused_field\n  final $foundDataSourceClass _dataSource = $foundDataSourceClass();\n\n';
    }

    final content = '''
${dataSourceImport}class ${className}Repository {
$dataSourceField  // Add repository operations
}
''';

    FileHelper.writeFile(targetPath, content);

    final useFvm =
        FvmHelper.shouldUseFvm(explicitFvm: argResults?['fvm'] == true);
    FvmHelper.runDart(['format', targetPath], useFvm: useFvm);

    print('Generated Repository: $targetPath');
  }
}
