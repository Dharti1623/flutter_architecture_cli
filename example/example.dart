import 'package:flutter_architecture_cli/flutter_architecture_cli.dart';

void main() {
  // Example of using the package utilities programmatically
  final camelCaseName = StringUtils.toCamelCase('my_awesome_feature');
  print('Camel case version of "my_awesome_feature": $camelCaseName');

  print('To run this CLI tool, activate it globally:');
  print('dart pub global activate flutter_architecture_cli');
  print('Then use it to create projects:');
  print('flutter_architecture_cli create my_app');
}
