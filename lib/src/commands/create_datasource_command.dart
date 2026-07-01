import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';

class CreateDataSourceCommand extends Command {
  @override
  final String name = 'create_datasource';

  @override
  final String description = 'Generates a new data source in the project.';

  CreateDataSourceCommand() {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'The target feature folder inside lib/src/ where the data source should be created.',
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
      print('Error: Please specify the data source name. Usage: clean_architecture_generator create_datasource <name>');
      return;
    }

    final dsName = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);
    final featureName = StringUtils.toSnakeCase(argResults?['feature'] ?? dsName);
    final packageName = _getPackageName();

    final targetPath = p.join(Directory.current.path, 'lib/src', featureName, 'data_source', '${dsName}_datasource.dart');

    FileHelper.writeFile(targetPath, '''
import 'package:$packageName/core/network/api_client.dart';

class ${className}DataSource {
  // ignore: unused_field
  final ApiClient _apiClient = ApiClient.instance;

  // Add datasource operations
}
''');

    print('Generated DataSource: $targetPath');
  }
}
