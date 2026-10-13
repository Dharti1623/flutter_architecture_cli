import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';
import '../utils/fvm_helper.dart';

class CreateServiceCommand extends Command {
  @override
  final String name = 'create_service';

  @override
  final String description = 'Generates a new core service in the project.';

  CreateServiceCommand() {
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
          'Error: Please specify the service name. Usage: flutter_architecture_cli create_service <name>');
      return;
    }

    final projectDir = FileHelper.findProjectRoot();
    final name = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);

    final targetPath =
        p.join(projectDir, 'lib/core/services', '${name}_service.dart');

    FileHelper.writeFile(targetPath, '''
class ${className}Service {
  static final ${className}Service _instance = ${className}Service._internal();

  factory ${className}Service() => _instance;

  ${className}Service._internal();

  Future<void> init() async {
    // Service initialization logic
  }
}
''');

    final useFvm =
        FvmHelper.shouldUseFvm(explicitFvm: argResults?['fvm'] == true);
    FvmHelper.runDart(['format', targetPath], useFvm: useFvm);

    print('Generated Service: $targetPath');
  }
}
