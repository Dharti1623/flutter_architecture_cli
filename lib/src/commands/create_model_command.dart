import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import '../utils/file_helper.dart';
import '../utils/string_utils.dart';

class CreateModelCommand extends Command {
  @override
  final String name = 'create_model';

  @override
  final String description = 'Generates a new data model and DTO in the project.';

  CreateModelCommand() {
    argParser.addOption(
      'feature',
      abbr: 'f',
      help: 'The target feature folder inside lib/src/ where the model should be created.',
    );
  }

  @override
  void run() {
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      print('Error: Please specify the model name. Usage: clean_architecture_generator create_model <model_name>');
      return;
    }

    final modelName = StringUtils.toSnakeCase(rest.first);
    final className = StringUtils.toPascalCase(rest.first);
    final featureName = StringUtils.toSnakeCase(argResults?['feature'] ?? modelName);

    final uiEntityPath = p.join(Directory.current.path, 'lib/src', featureName, 'model', 'ui_entity', '${modelName}_ui_entity.dart');
    final responsePath = p.join(Directory.current.path, 'lib/src', featureName, 'model', 'response', '${modelName}_response.dart');

    // Create subdirectories if they do not exist
    final uiEntityDir = Directory(p.dirname(uiEntityPath));
    if (!uiEntityDir.existsSync()) uiEntityDir.createSync(recursive: true);
    final responseDir = Directory(p.dirname(responsePath));
    if (!responseDir.existsSync()) responseDir.createSync(recursive: true);

    FileHelper.writeFile(uiEntityPath, '''
class ${className}UiEntity {
  final int id;

  ${className}UiEntity({
    required this.id,
  });
}
''');

    FileHelper.writeFile(responsePath, '''
class ${className}Response {
  int? id;

  ${className}Response({
    this.id,
  });

  ${className}Response.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
''');

    print('Generated UI Entity: $uiEntityPath');
    print('Generated Response: $responsePath');
  }
}

