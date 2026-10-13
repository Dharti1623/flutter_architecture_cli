import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';
import '../utils/fvm_helper.dart';

class CreateDataSourceCommand extends Command {
  @override
  final String name = 'create_datasource';

  @override
  final String description = 'Generates a new data source in the project.';

  CreateDataSourceCommand() {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help:
          'The target feature folder inside lib/src/ where the data source should be created.',
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
          'Error: Please specify the data source name. Usage: flutter_architecture_cli create_datasource <name>');
      return;
    }

    final projectDir = FileHelper.findProjectRoot();
    final dsName = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);
    final featureName =
        StringUtils.toSnakeCase(argResults?['feature'] ?? dsName);
    final packageName = FileHelper.getPackageName(projectDir);

    final targetPath = p.join(projectDir, 'lib/src', featureName, 'data_source',
        '${dsName}_datasource.dart');

    FileHelper.writeFile(targetPath, '''
import 'package:$packageName/core/network/api_client.dart';

class ${className}DataSource {
  // ignore: unused_field
  final ApiClient _apiClient = ApiClient.instance;

  // Add datasource operations
}
''');

    final useFvm =
        FvmHelper.shouldUseFvm(explicitFvm: argResults?['fvm'] == true);
    FvmHelper.runDart(['format', targetPath], useFvm: useFvm);

    print('Generated DataSource: $targetPath');
  }
}
