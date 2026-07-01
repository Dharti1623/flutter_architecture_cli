import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:flutter_architecture_cli/src/commands/create_app_command.dart';
import 'package:flutter_architecture_cli/src/commands/create_screen_command.dart';
import 'package:flutter_architecture_cli/src/commands/create_feature_command.dart';
import 'package:flutter_architecture_cli/src/commands/create_model_command.dart';
import 'package:flutter_architecture_cli/src/commands/create_repository_command.dart';
import 'package:flutter_architecture_cli/src/commands/create_datasource_command.dart';
import 'package:flutter_architecture_cli/src/commands/create_service_command.dart';
import 'package:flutter_architecture_cli/src/commands/change_bundle_id_command.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner(
    'flutter_architecture_cli',
    'CLI tool to generate clean architecture boilerplate for Flutter applications.',
  )
    ..addCommand(CreateAppCommand())
    ..addCommand(CreateScreenCommand())
    ..addCommand(CreateFeatureCommand())
    ..addCommand(CreateModelCommand())
    ..addCommand(CreateRepositoryCommand())
    ..addCommand(CreateDataSourceCommand())
    ..addCommand(CreateServiceCommand())
    ..addCommand(ChangeBundleIdCommand());

  try {
    await runner.run(arguments);
  } catch (error) {
    if (error is UsageException) {
      print(error.message);
      print(error.usage);
      exit(64);
    }
    print('Unexpected error: $error');
    exit(1);
  }
}
